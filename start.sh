#!/bin/bash

user_name=$(whoami)

./remove.sh
docker build -t dev-docker \
  --build-arg user_name=$user_name \
  --build-arg user_id=$(id -u) \
  .
docker run -td \
  --name dev-docker \
  -v ~/Developer:/home/$user_name/Developer \
  dev-docker:latest
