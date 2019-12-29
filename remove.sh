#!/bin/bash

container_id=$(docker ps -qf "ancestor=dev-docker")
docker stop $container_id
