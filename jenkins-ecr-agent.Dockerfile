FROM debian:12-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    ca-certificates \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

# AWS CLI
RUN curl -s "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o awscliv2.zip \
    && unzip -q awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws/

# kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Docker Buildx plugin (new)
RUN mkdir -p ~/.docker/cli-plugins \
    && curl -L "https://github.com/docker/buildx/releases/download/v0.37.2/buildx-v0.37.2.linux-arm64" \
    -o ~/.docker/cli-plugins/docker-buildx \
    && chmod +x ~/.docker/cli-plugins/docker-buildx

RUN aws --version && docker --version && kubectl version --client && helm version && docker buildx version