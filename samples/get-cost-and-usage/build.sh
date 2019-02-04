#!/bin/bash

[ ! -d ./layer/awscli ] && mkdir -p ./layer/awscli
[ ! -d ./layer/lib ] && mkdir -p ./layer/lib

docker build -t awscli:amazonlinux .
CONTAINER=$(docker run -d awscli:amazonlinux false)
docker cp ${CONTAINER}:/opt/awscli/lib/python2.7/site-packages/ layer/awscli/
docker cp ${CONTAINER}:/opt/awscli/bin/ layer/awscli/
docker cp ${CONTAINER}:/opt/awscli/lib64/libncurses.so.6 layer/lib/
docker cp ${CONTAINER}:/opt/awscli/lib64/libtinfo.so.6 layer/lib

docker rm -f ${CONTAINER}


mv layer/awscli/site-packages/* layer/awscli/
cp layer/awscli/bin/aws layer/awscli/aws

# bc
cp layer/awscli/bin/bc layer/awscli/bc

# # extra libs
# mv layer/awscli/lib64/* layer/

# remove unnecessary files to reduce the size
rm -rf layer/awscli/pip* layer/awscli/setuptools* layer/awscli/awscli/examples

# install jq
wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
mv jq-linux64 layer/awscli/jq
chmod +x layer/awscli/jq

# cd layer; zip -r ../layer.zip *
