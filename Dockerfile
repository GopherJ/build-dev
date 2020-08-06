FROM ekidd/rust-musl-builder:nightly-2020-03-12
MAINTAINER Cheng JIANG <alex_cj96@foxmail.com>

USER rust

ARG NODE_VERSION
ARG GO_VERSION

ENV DEBIAN_FRONTEND noninteractive
ENV GOENV_DIR=/home/rust/.goenv

RUN sudo apt-get update --fix-missing -y && \
    sudo apt-get install openssh-client libssl-dev git wget -y

# Install goenv
RUN git clone https://github.com/syndbg/goenv.git ~/.goenv \
    && export GOENV_ROOT="$HOME/.goenv" \
    && export PATH="$GOROOT/bin:$GOPATH/bin:$GOENV_ROOT/bin:$PATH" \
    && eval "$(goenv init -)" \
    && goenv install $GO_VERSION

# Install upx
RUN wget https://github.com/upx/upx/releases/download/v3.94/upx-3.94-amd64_linux.tar.xz \
    && sudo tar -xJf upx-3.94-amd64_linux.tar.xz \
    && sudo chmod u+x upx-3.94-amd64_linux/upx \
    && sudo mv upx-3.94-amd64_linux/upx /usr/local/bin

# Install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash && \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" && \
    nvm install $NODE_VERSION && \
    nvm use $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm install-latest-npm && \
    npm install -g yarn
