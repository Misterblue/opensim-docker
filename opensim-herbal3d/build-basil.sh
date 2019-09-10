#! /bin/bash
# Build docker image for sourcing BasilJS

docker build \
    --pull \
    --no-cache \
    -t basiljs-herbal3d \
    -f Dockerfile-basiljs \
    .
