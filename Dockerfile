FROM ubuntu:20.04
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y \
    vim \
    tmux \
    curl \
    git \
    ruby-full \
    build-essential \
    zlib1g-dev

RUN apt-get update && apt-get install -y \
    mit-scheme

ARG user_name
ARG user_id
ARG term
RUN useradd -m -u ${user_id} ${user_name}
USER ${user_name}
ENV HOME /home/${user_name}
ENV TERM ${term}
WORKDIR $HOME

RUN git clone https://github.com/canitgeneralize/dotfiles.git \
  && cd $HOME/dotfiles \
  && ./install.sh \
  && cd .. \
  && rm -rf ./dotfiles

ENV GEM_HOME $HOME/gems
ENV PATH $HOME/gems/bin:$PATH
RUN gem install jekyll bundler

RUN curl -O https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh \
  && bash Anaconda3-2019.10-Linux-x86_64.sh -b \
  && ./anaconda3/bin/conda init \
  && rm Anaconda3-2019.10-Linux-x86_64.sh
