#! /bin/bash
# Build docker images for running a Herbal3d version of OpenSimulator

BASE=$(dirname $(realpath -e $(which $0)))

docker build \
    -t opensim-herbal3d \
    .
