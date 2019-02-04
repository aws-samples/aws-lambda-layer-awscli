FROM amazonlinux:latest

WORKDIR /root

RUN yum update -y && yum install -y unzip bc

ADD https://s3.amazonaws.com/aws-cli/awscli-bundle.zip /root

    
RUN unzip awscli-bundle.zip && \
    cd awscli-bundle;
    
#RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
RUN ./awscli-bundle/install -i /opt/awscli -b /opt/awscli/aws

# install bc
RUN cp /usr/bin/bc /opt/awscli/bin/ \
&& cp /lib64/libncurses.so.6 /opt/awscli/lib64/ \
&& cp /lib64/libtinfo.so.6 /opt/awscli/lib64/

  
    
