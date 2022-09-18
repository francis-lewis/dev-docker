#!/bin/bash

user_name=$(whoami)
container_name="dev-docker"

./remove.sh
docker build -t $container_name \
  --build-arg user_name=$user_name \
  --build-arg user_id=$(id -u) \
  --build-arg term=$(echo $TERM) \
  --build-arg docker_gid=$(getent group docker | cut -d: -f3) \
  .

docker run -td \
  --name $container_name \
  -v ~/Developer:/home/$user_name/Developer \
  -v /tmp:/tmp \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e DISPLAY=$(echo $DISPLAY) \
  --network host \
  --gpus all \
  dev-docker:latest
