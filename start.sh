#!/bin/bash

user_name=$(whoami)
container_name="dev-docker"

./remove.sh
docker build -t $container_name \
  --build-arg user_name=$user_name \
  --build-arg user_id=$(id -u) \
  --build-arg term=$(echo $TERM) \
  .
docker run -td \
  --name $container_name \
  -v ~/Developer:/home/$user_name/Developer \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=$(echo $DISPLAY) \
  --network host \
  --gpus all \
  dev-docker:latest
