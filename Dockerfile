FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive
ARG TERRAFORM_VERSION="0.14.8"
ARG TERRAFORM_DOCS_VERSION="0.12.1"
ARG TFLINT_VERSION="0.27.0"

RUN apt-get update && \
    apt-get install -y \
    python3-pip \
    openssh-client \
    build-essential \
    git \
    curl \
    wget \
    jq \
    graphviz \
    unzip && \
    pip3 install boto3 awscli

RUN cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin && \
    curl --location https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip --output tflint.zip && \
    unzip tflint.zip && rm tflint.zip && \
    mv tflint /usr/local/bin

RUN cd /tmp && \
    wget https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 && \
    mv terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 /usr/local/bin/terraform-docs && \
    chmod 755 /usr/local/bin/terraform-docs

RUN cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin && \
    curl --location https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip --output tflint.zip && \
    unzip tflint.zip && rm tflint.zip && \
    mv tflint /usr/local/bin

RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl && \
    curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y kubectl

WORKDIR /home/device-manager