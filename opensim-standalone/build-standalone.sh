#! /bin/bash
# Build docker images for running a standalone version of OpenSimulator

BUILD_DATE=$(date "+%Y%m%d.%H%M")
BUILD_DAY=$(date "+%Y%m%d")
OS_DOCKER_VERSION=$(cat ../VERSION.txt)
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
GIT_COMMIT=$(git rev-parse HEAD)
GIT_COMMIT_SHORT=$(git rev-parse --short HEAD)

# Note that the '--no-cache' is here to force refetching of the OpenSimulator git sources
#    --no-cache
docker build \
    --build-arg BUILD_DATE=$BUILD_DATE \
    --build-arg BUILD_DAY=$BUILD_DAY \
    --build-arg OS_DOCKER_VERSION=$OS_DOCKER_VERSION \
    --build-arg OS_DOCKER_GIT_BRANCH=$GIT_BRANCH \
    --build-arg OS_DOCKER_GIT_COMMIT=$GIT_COMMIT \
    --build-arg OS_DOCKER_GIT_COMMIT_SHORT=$GIT_COMMIT_SHORT \
    -t opensim-standalone \
    -f Dockerfile-standalone \
    .
