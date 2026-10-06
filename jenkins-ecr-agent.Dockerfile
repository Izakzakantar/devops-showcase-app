FROM debian:12-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    ca-certificates \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

# AWS CLI (already working, unchanged)
RUN curl -s "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o awscliv2.zip \
    && unzip -q awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws/

# kubectl (new)
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# Helm (new)
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

RUN aws --version && docker --version && kubectl version --client && helm version