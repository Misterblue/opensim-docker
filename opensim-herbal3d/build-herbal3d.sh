#! /bin/bash
# Build docker images for running a Herbal3d version of OpenSimulator

docker build \
    --pull \
    --no-cache \
    -t opensim-herbal3d \
    -f Dockerfile-herbal3d \
    .
