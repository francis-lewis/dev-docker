FROM ubuntu:18.04
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y \
    vim \
    tmux \
    curl \
    git

ARG user_name
ARG user_id
RUN useradd -m -u ${user_id} ${user_name}
USER ${user_name}
WORKDIR /home/${user_name}

RUN git clone https://github.com/glewis17/dotfiles.git \
    && cd ./dotfiles \
    && ./install.sh \
    && cd .. \
    && rm -rf ./dotfiles
