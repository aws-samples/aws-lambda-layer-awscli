FROM lambci/lambda:build-python3.8 as builder

WORKDIR /root

RUN yum -y install zip
ADD https://s3.amazonaws.com/aws-cli/awscli-bundle.zip /root
RUN unzip awscli-bundle.zip && \
    cd awscli-bundle;
RUN ./awscli-bundle/install -i /opt/awscli -b /opt/awscli/aws

# install jq
ADD https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 /root/
RUN chmod +x /root/jq-linux64

FROM lambci/lambda:build-python3.8 as runtime

USER root

COPY --from=builder /opt/awscli/lib/python3.8/site-packages/ /opt/awscli/
COPY --from=builder /opt/awscli/bin/ /opt/awscli/bin/
COPY --from=builder /opt/awscli/bin/aws /opt/awscli/aws
COPY --from=builder /root/jq-linux64 /opt/awscli/jq
COPY --from=builder /usr/bin/make /opt/awscli/make
COPY --from=builder /lib64/libpython3.7m.so.1.0 /opt/lib/
COPY --from=builder /lib64/libffi.so.6 /opt/lib/
COPY --from=builder /lib64/libc.so.6 /opt/lib/
COPY --from=builder /lib64/libcrypt.so.1 /opt/lib/

# remove unnecessary files to reduce the size
RUN rm -rf /opt/awscli/pip* /opt/awscli/setuptools* /opt/awscli/awscli/examples

RUN /opt/awscli/aws --version  > /AWSCLI_VERSION_INFO

# zip up
RUN cd /opt; zip -r ../layer.zip *; \
echo "/layer.zip is ready"; \
ls -alh /layer.zip;

ENV PATH="/opt/awscli:${PATH}"
