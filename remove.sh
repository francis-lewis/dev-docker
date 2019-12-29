#!/bin/bash

container_id=$(docker ps -aqf "name=dev-docker")
if [[ ! -z $container_id ]]; then
  docker stop $container_id
  docker rm $container_id
fi
