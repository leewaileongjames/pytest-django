#!/bin/bash

# Cleanup any running containers

if [[ ! -z "$(docker ps -qa)" ]]
then
  docker stop $(docker ps -qa)
  docker rm $(docker ps -qa)
fi

# Cleanup any images

if [[ ! -z "$(docker images -q)" ]]
then
  echo "Deleting images"
  docker rmi $(docker images -q) --force
fi
