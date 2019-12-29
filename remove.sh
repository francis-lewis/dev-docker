#!/bin/bash

container_id=$(docker ps -aqf "ancestor=dev-docker")
docker stop $container_id
docker rm $container_id
