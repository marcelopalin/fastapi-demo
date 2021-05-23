#!/bin/bash
# https://www.hostinger.com/tutorials/docker-remove-all-images-tutorial/
docker container stop $(docker container ls -aq) && docker system prune -af --volumes
