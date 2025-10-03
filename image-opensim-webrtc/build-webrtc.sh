#! /bin/bash
# Build docker images for running OpenSimulator with webrtc

BUILD_DATE=$(date "+%Y%m%d.%H%M")
BUILD_DAY=$(date "+%Y%m%d")
# version infomation about opensim-docker
OS_DOCKER_VERSION=$(cat ../VERSION.txt)
OS_DOCKER_GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
OS_DOCKER_GIT_COMMIT=$(git rev-parse HEAD)
OS_DOCKER_GIT_COMMIT_SHORT=$(git rev-parse --short HEAD)

# Set up the environment with all the environment build parameters
source ./env

# Copy the run-scripts into the local directory here since the Docker build
#     only knowns the context of this directory
rm -rf temp-run-scripts
cp -r ../run-scripts temp-run-scripts

# Build the image
docker build \
    --pull \
    --build-arg BUILD_DATE=$BUILD_DATE \
    --build-arg BUILD_DAY=$BUILD_DAY \
    --build-arg OS_DOCKER_VERSION=$OS_DOCKER_VERSION \
    --build-arg OS_DOCKER_GIT_BRANCH=$OS_DOCKER_GIT_BRANCH \
    --build-arg OS_DOCKER_GIT_COMMIT=$OS_DOCKER_GIT_COMMIT \
    --build-arg OS_DOCKER_GIT_COMMIT_SHORT=$OS_DOCKER_GIT_COMMIT_SHORT \
    --build-arg OS_GIT_REPO=$OS_GIT_REPO \
    --build-arg OS_GIT_BRANCH=$OS_GIT_BRANCH \
    --build-arg OS_BUILDTARGET=$OS_BUILDTARGET \
    --build-arg OS_SLN=$OS_SLN \
    --build-arg WEBRTC_BRANCH=$WEBRTC_BRANCH \
    -t "$IMAGE_NAME" \
    -f Dockerfile-webrtc \
    .

# Remove the temporarily copied run-scripts to reduce any confusion
rm -rf temp-run-scripts
