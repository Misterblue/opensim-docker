#! /bin/bash
# Build docker image for sourcing Basilts

docker build \
    --pull \
    -t basil-herbal3d \
    -f Dockerfile-basil \
    .
