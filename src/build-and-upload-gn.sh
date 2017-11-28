#!/bin/bash

M=$(uname -m)

# cleanup
rm -rf /workdir && mkdir /workdir && cd /workdir

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
cd /workdir && \
    fetch --no-history --nohooks chromium && \
    touch /workdir/src/build/util/LASTCHANGE

  if [[ $? -ne 0 ]] ; then
    echo "Unable to fetch chromium"
    exit -1
  fi

generate_and_build() {
  OUT=$1
  cd /workdir/src  && \
      $GN gen $OUT --args='enable_nacl=false use_allocator="none" is_component_build=false is_debug=false use_custom_libcxx=false' && \
      ninja -C $OUT gn
}

# generate and build gn
GN=/buildtools/buildtools-$M/gn generate_and_build out
if [[ $? -ne 0 ]] ; then
  echo "Unable to build gn"
  exit -1
fi

# test: build itself
GN=/workdir/src/out/gn generate_and_build out_test
if [[ $? -ne 0 ]] ; then
  echo "Unable to pass test."
  exit -1
fi

cp /workdir/src/out/gn /buildtools/buildtools-$M/gn
VERSION=$(/buildtools/buildtools-$M/gn --version)
cd /buildtools
git commit ./buildtools-$M/gn -m "GN: Update $M gn to $VERSION"
git push

