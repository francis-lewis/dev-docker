#!/bin/bash

container_id=$(docker ps -qf "name=dev-docker")
docker exec -it $container_id /bin/bash
