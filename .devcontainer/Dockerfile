FROM mcr.microsoft.com/devcontainers/base:alpine

USER root

RUN apk add --no-cache \
    bash \
    ca-certificates \
    curl \
    git \
    github-cli \
    jq \
    openssh-client \
    shellcheck \
    docker-cli \
    docker-cli-compose \
    docker-cli-buildx \
    coreutils \
    findutils \
    grep \
    sed

USER vscode