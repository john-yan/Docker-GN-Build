#!/bin/bash

IMAGE=gn-build-env
OLD_IMAGE=$(docker images -q $IMAGE)

docker build -q -t $IMAGE .

NEW_IMAGE=$(docker images -q $IMAGE)

if [[ $OLD_IMAGE != $NEW_IMAGE ]] ; then
  echo "docker image $OLD_IMAGE has been updated as $NEW_IMAGE"
  docker rmi $OLD_IMAGE
fi
