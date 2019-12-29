#!/bin/bash

container_id=$(docker ps -qf "ancestor=dev-docker")
docker exec -it $container_id /bin/bash
