#!/bin/bash

./remove.sh
docker build -t dev-docker .
docker run -td \
  --name dev-docker \
  dev-docker:latest
