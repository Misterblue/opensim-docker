#! /bin/bash
# Build docker images for running a standalone version of OpenSimulator

# Note that the '--no-cache' is here to force refetching of the OpenSimulator git sources
docker build \
    --pull \
    --no-cache \
    -t opensim-standalone \
    -f Dockerfile-standalone \
    .
