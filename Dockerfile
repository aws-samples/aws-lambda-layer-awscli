FROM amazonlinux:latest

WORKDIR /root

RUN yum update -y && yum install -y unzip

ADD https://s3.amazonaws.com/aws-cli/awscli-bundle.zip /root

    
RUN unzip awscli-bundle.zip && \
    cd awscli-bundle;
    
#RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
RUN ./awscli-bundle/install -i /opt/awscli -b /opt/awscli/aws
  
    
