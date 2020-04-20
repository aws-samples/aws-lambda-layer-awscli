#!/bin/bash

#[ ! -d ./layer/awscli ] && mkdir -p ./layer/awscli

# [ ! -d ./layer ] && mkdir -p ./layer

docker build -t awscli:amazonlinux .
CONTAINER=$(docker run -d awscli:amazonlinux false)
docker cp ${CONTAINER}:/layer.zip layer.zip
docker cp ${CONTAINER}:/AWSCLI_VERSION AWSCLI_VERSION
docker cp ${CONTAINER}:/AWSCLI_VERSION_INFO AWSCLI_VERSION_INFO



exit 0

CONTAINER=$(docker run -d awscli:amazonlinux false)
docker cp ${CONTAINER}:/opt/awscli/lib/python2.7/site-packages/ layer/awscli/
docker cp ${CONTAINER}:/opt/awscli/bin/ layer/awscli/
docker rm -f ${CONTAINER}


mv layer/awscli/site-packages/* layer/awscli/
cp layer/awscli/bin/aws layer/awscli/aws
# remove unnecessary files to reduce the size
rm -rf layer/awscli/pip* layer/awscli/setuptools* layer/awscli/awscli/examples

# install jq
wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
mv jq-linux64 layer/awscli/jq
chmod +x layer/awscli/jq

# cd layer; zip -r ../layer.zip *
