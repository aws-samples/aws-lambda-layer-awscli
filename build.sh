#!/bin/bash

while getopts "f:" arg; do
  case $arg in
    f) dockerfile=$OPTARG;;
  esac
done

if [[ -n $dockerfile ]]; then
  echo "build with $dockerfile"
  docker build -t awscli:amazonlinux . -f $dockerfile
else
  echo "build with Dockerfile"
  docker build -t awscli:amazonlinux .
fi

CONTAINER=$(docker run -d awscli:amazonlinux false)
docker cp ${CONTAINER}:/layer.zip layer.zip
docker cp ${CONTAINER}:/AWSCLI_VERSION AWSCLI_VERSION

exit 0
