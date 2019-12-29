#!/bin/bash

./remove.sh
docker build -t dev-docker .
docker run -td dev-docker:latest
