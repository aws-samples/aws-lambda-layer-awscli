FROM amazonlinux:latest as builder

WORKDIR /root

RUN yum update -y && yum install -y unzip make wget

ADD https://s3.amazonaws.com/aws-cli/awscli-bundle.zip /root

    
RUN unzip awscli-bundle.zip && \
    cd awscli-bundle;
    
#RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
RUN ./awscli-bundle/install -i /opt/awscli -b /opt/awscli/aws
  
# install jq
RUN wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 \
&& mv jq-linux64 /opt/awscli/jq \
&& chmod +x /opt/awscli/jq
  
#
# prepare the runtime at /opt/awscli
#
  
FROM lambci/lambda:provided as runtime

USER root

RUN yum install -y zip 

COPY --from=builder /opt/awscli/lib/python2.7/site-packages/ /opt/awscli/ 
COPY --from=builder /opt/awscli/bin/ /opt/awscli/bin/ 
COPY --from=builder /opt/awscli/bin/aws /opt/awscli/aws; 
COPY --from=builder /opt/awscli/jq /opt/awscli/jq; 
COPY --from=builder /usr/bin/make /opt/awscli/make; 

# remove unnecessary files to reduce the size
RUN rm -rf /opt/awscli/pip* /opt/awscli/setuptools* /opt/awscli/awscli/examples

#&& mv /opt/awscli/site-packages/* /opt/awscli/

# get the version number
RUN grep "__version__" /opt/awscli/awscli/__init__.py | egrep -o "1.[0-9.]+" > /AWSCLI_VERSION

# zip up
RUN cd /opt; zip -r ../layer.zip *; \
echo "/layer.zip is ready"; \
ls -alh /layer.zip;


