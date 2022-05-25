#! /bin/bash
# Build docker image for sourcing BasilJS

docker build \
    --pull \
    -t basilts-herbal3d \
    -f Dockerfile-basiljs \
    .
