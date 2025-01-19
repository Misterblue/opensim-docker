#! /bin/bash
# Stop the running opensimulator

BASE=$(pwd)

# Get the container parameters into the environment
# (Needs to be in the environment for the docker-compose.yml file)
source ./envToEnvironment.sh

export OS_CONFIG=${OS_CONFIG:-standalone}

echo "Restarting configuration $CONFIG_NAME from docker-compose.yml"

docker compose \
    --file docker-compose.yml \
    --env-file ./env \
    --project-name opensim-${OS_CONFIG} \
    restart
