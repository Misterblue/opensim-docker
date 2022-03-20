#! /bin/bash
# Build docker image for sourcing BasilJS

docker build \
    --pull \
    -t basil-herbal3d \
    -f Dockerfile-basil \
    .
