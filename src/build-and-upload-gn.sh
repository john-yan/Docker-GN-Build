#!/bin/bash

M=$(uname -m)

# cleanup
rm -rf /workdir && mkdir /workdir && cd /workdir

# Report disk info
df -h

# setup ssh config as host
cp -r /root/host_home/.ssh /root/.ssh

# setup git config as host
cp /root/host_home/.gitconfig /root/.gitconfig

# download buildtools
if [[ ! -d /buildtools ]] ; then
  git clone git@github.com:john-yan/ibm-buildtools-for-v8.git /buildtools
  if [[ $? -ne 0 ]] ; then
    echo "Unable to git clone buildtools"
    exit -1
  fi
fi

# fetch and prepare src
cd /workdir && git clone https://gn.googlesource.com/gn
if [[ $? -ne 0 ]] ; then
  echo "Unable to fetch gn"
  exit -1
fi

# generate and build gn
cd /workdir/gn && python build/gen.py --no-sysroot && ninja -C out

# test
out/gn_unittests
if [[ $? -ne 0 ]] ; then
  echo "gn unittests failing"
  exit -1
fi

OLD_VERSION=$(/buildtools/buildtools-$M/gn --version)
NEW_VERSION=$(/workdir/gn/out/gn --version)
if [[ $OLD_VERSION == $NEW_VERSION ]] ; then
  echo "Already on latest gn version"
  exit 0
fi

cp /workdir/gn/out/gn /buildtools/buildtools-$M/gn
cd /buildtools
git commit ./buildtools-$M/gn -m "GN: Update $M gn to $NEW_VERSION"
git push

