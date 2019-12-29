FROM ubuntu:18.04
SHELL ["/bin/bash", "-c"]
RUN apt-get update && apt-get install -y \
    vim \
    tmux \
    curl \
    git
WORKDIR /root
RUN git clone https://github.com/glewis17/dotfiles.git \
    && cd ./dotfiles \
    && ./install.sh \
    && cd .. \
    && rm -rf ./dotfiles
