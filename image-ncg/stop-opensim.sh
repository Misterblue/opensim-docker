#! /bin/bash
# Stop the running opensimulator

BASE=$(pwd)

# Get the container parameters into the environment
# source ./envToEnvironment.sh
source ./env

export OS_CONFIG=${OS_CONFIG:-standalone}

echo "Stopping configuration $OS_CONFIG from docker-compose.sh"

docker-compose \
    --file docker-compose.yml \
    --env-file ./env \
    --project-name opensim-${OS_CONFIG} \
    down
