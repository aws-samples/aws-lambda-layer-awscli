FROM amazonlinux:latest as builder

WORKDIR /root

RUN yum update -y && yum install -y unzip make wget

ADD https://s3.amazonaws.com/aws-cli/awscli-bundle.zip /root

    
RUN unzip awscli-bundle.zip
    
#RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
RUN ./awscli-bundle/install -i /opt/awscli -b /opt/awscli/aws

# install jq
RUN wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 \
&& mv jq-linux64 /opt/awscli/jq \
&& chmod +x /opt/awscli/jq

# resolve symlinks
RUN cp -RL /opt/awscli /opt/awscli-resolved

#
# prepare the runtime at /opt/awscli
#

FROM lambci/lambda:provided as prepareCli

USER root

COPY --from=builder /opt/awscli-resolved/lib/python2.7/site-packages/ /opt/awscli/
COPY --from=builder /opt/awscli-resolved/bin/ /opt/awscli/bin/
COPY --from=builder /opt/awscli-resolved/jq /opt/awscli/jq
COPY --from=builder /usr/bin/make /opt/awscli/make
COPY --from=builder /usr/lib64/libpython2.7.so.1.0 /opt/awscli/lib64/libpython2.7.so.1.0
COPY --from=builder /usr/lib64/libexpat.so.1 /opt/awscli/lib64/libexpat.so.1
COPY --from=builder /usr/lib64/python2.7/ /opt/awscli/lib64/python2.7

# create a wrapper for the bin with the new lib path.
RUN echo '#!/bin/bash' > /opt/awscli/aws \
&& echo 'PYTHONPATH=/opt/awscli LD_LIBRARY_PATH=/opt/awscli/lib64/ /opt/awscli/bin/aws $@' >> /opt/awscli/aws \
&& chmod +x /opt/awscli/aws

# remove unnecessary files to reduce the size
RUN rm -rf /opt/awscli/pip* /opt/awscli/setuptools* /opt/awscli/awscli/examples

# get the version number
RUN grep "__version__" /opt/awscli/awscli/__init__.py | egrep -o "1.[0-9.]+" > /AWSCLI_VERSION

#
# ensure no missing linked libraries
# NOTE that this is only checking the Python executable! It may need to be expanded upon later.
#
FROM lambci/lambda:nodejs12.x as testNodeJs12x

USER root

COPY --from=prepareCli /opt/awscli/ /opt/awscli/

ENV LD_LIBRARY_PATH /opt/awscli/lib64/
COPY lddtest ./lddtest
COPY lddtest ./lddtest
RUN ./lddtest /opt/awscli/bin/python

#
# zip up
#
FROM lambci/lambda:provided as runtime

USER root

COPY --from=prepareCli /opt/awscli/ /opt/awscli/
COPY --from=prepareCli /AWSCLI_VERSION /AWSCLI_VERSION

RUN yum install -y zip
RUN cd /opt; zip -r ../layer.zip *; \
echo "/layer.zip is ready"; \
ls -alh /layer.zip;

#extend PATH with new layer
ENV PATH="/opt/awscli:${PATH}"
