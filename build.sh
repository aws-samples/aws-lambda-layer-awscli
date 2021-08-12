#!/bin/bash

while getopts "f:" arg; do
  case $arg in
    f) dockerfile=$OPTARG;;
  esac
done

if [[ -n $dockerfile ]]; then
  echo "build with $dockerfile"
  docker build -t lambci/lambda:build-python3.8 . -f $dockerfile
else
  echo "build with Dockerfile"
  docker build -t lambci/lambda:build-python3.8 .
fi

CONTAINER=$(docker run -d lambci/lambda:build-python3.8 false)
docker cp ${CONTAINER}:/layer.zip layer.zip
docker cp ${CONTAINER}:/AWSCLI_VERSION_INFO AWSCLI_VERSION_INFO

exit 0
