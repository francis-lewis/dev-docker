FROM pytorch/pytorch:1.12.1-cuda11.3-cudnn8-runtime
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y \
    apt-utils \
    build-essential

RUN apt-get update && apt-get install -y \
    curl \
    git \
    ruby-full \
    tmux \
    vim \
    wget \
    zlib1g-dev

RUN apt-get update && apt-get install -y \
    libosmesa6-dev \
    libgl1-mesa-glx \
    libglew-dev \
    libglfw3 \
    mesa-utils
# Necessary for mujoco
ENV LD_PRELOAD=$LD_PRELOAD:/usr/lib/x86_64-linux-gnu/libGLEW.so

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

ENV PATH=$PATH:$HOME/.local/bin

RUN git clone https://github.com/francis-lewis/dotfiles.git \
  && cd $HOME/dotfiles \
  && ./install.sh \
  && cd .. \
  && rm -rf ./dotfiles

RUN echo "PS1='🐳  \[\033[1;36m\]\w\[\033[0;35m\] \[\033[1;36m\]$ \[\033[0m\]'" >> /home/${user_name}/.bashrc

# Install mujoco
RUN mkdir $HOME/.mujoco \
  && cd $HOME/.mujoco \
  && wget https://mujoco.org/download/mujoco210-linux-x86_64.tar.gz \
  && tar -zxvf mujoco210-linux-x86_64.tar.gz \
  && rm mujoco210-linux-x86_64.tar.gz \
  && cd $HOME
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.mujoco/mujoco210/bin
RUN pip install mujoco_py
RUN python -m mujoco_py || true

RUN pip install jupyter

#ENV GEM_HOME $HOME/gems
#ENV PATH $HOME/gems/bin:$PATH
#RUN gem install jekyll bundler

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,graphics
