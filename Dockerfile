FROM pytorch/pytorch:1.12.1-cuda11.3-cudnn8-runtime
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y \
    apt-utils \
    build-essential\
    lsb-release

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gdb \
    git \
    gnupg \
    iproute2 \
    tmux \
    vim \
    wget \
    zlib1g-dev

RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglew-dev \
    libglfw3 \
    libosmesa6-dev \
    libsdl2-dev \
    mesa-utils
# Necessary for mujoco
ENV LD_PRELOAD=$LD_PRELOAD:/usr/lib/x86_64-linux-gnu/libGLEW.so

# Install docker
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update && apt-get install -y \
    containerd.io \
    docker-ce \
    docker-ce-cli \
    docker-compose-plugin
ARG docker_gid
RUN groupdel docker && \
    groupadd -g ${docker_gid} docker

RUN apt-get update && apt-get install -y \
    mit-scheme

ARG user_name
ARG user_id
ARG term
RUN useradd -m -u ${user_id} ${user_name}

RUN usermod -aG docker ${user_name}

USER ${user_name}
ENV HOME /home/${user_name}
ENV TERM ${term}
WORKDIR $HOME

ENV PATH=$PATH:$HOME/.local/bin

ENV GIT_PROMPT_THEME=Single_line_Dark
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
RUN pip install gym[all,accept-rom-license]

# Install determined
RUN pip install determined

#ENV GEM_HOME $HOME/gems
#ENV PATH $HOME/gems/bin:$PATH
#RUN gem install jekyll bundler

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,graphics
