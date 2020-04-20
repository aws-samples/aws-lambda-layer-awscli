FROM lambci/lambda:build-python3.8 as builder

WORKDIR /root

ADD https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip /root/awscliv2.zip
RUN unzip awscliv2.zip && ./aws/install

# install jq
ADD https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 /root/

RUN chmod +x /root/jq-linux64


FROM lambci/lambda:build-python3.8 as packer

USER root

COPY --from=builder /usr/local/aws-cli/v2/current/dist/ /opt/awscli/
COPY --from=builder /root/jq-linux64 /opt/awscli/jq
COPY --from=builder /usr/bin/make /opt/awscli/make

RUN /opt/awscli/aws --version  > /AWSCLI_VERSION_INFO

# zip up
RUN cd /opt; zip -r ../layer.zip *; \
    echo "/layer.zip is ready"; \
    ls -alh /layer.zip;

# extend PATH with new layer
ENV PATH="/opt/awscli:${PATH}"

