#! /bin/bash
# Run the OpenSimulator image

# Since the initial run has to create and initialize the MYSQL database
#    the first time, this sets the passwords into the environment before
#    running things.

# Be sure to set environment variables:
#    OS_CONFIG=nameOfRunConfiguration (default 'standalone' of not supplied)

BASE=$(pwd)

# Get the container parameters into the environment
# source ./envToEnvironment.sh
source ./env

# The selects the configuration to mount and use in the Docker image
export OS_CONFIG=${OS_CONFIG:-standalone}
echo "Using configuration \"$OS_CONFIG\""

# Get the secrets for the environment
# (the following 'export' fakes out 'setEnvironment' to use the local directory
export OPENSIMCONFIG=${BASE}/config-${OS_CONFIG}
source ${OPENSIMCONFIG}/scripts/setEnvironment.sh

# Local directory for storage of sql persistant data (so region
#    contents persists between container restarts).
# This must be the same directory as in $COMPOSEFILE
if [[ ! -d "$HOME/opensim-sql-data" ]] ; then
    echo "Directory \"$HOME/opensim-sql-data/\" does not exist. Creating same."
    mkdir -p "$HOME/opensim-sql-data"
    chmod o+w "$HOME/opensim-sql-data"
fi

cd "${BASE}"

# https://docs.docker.com/engine/security/userns-remap/
# --userns-remap="opensim:opensim"
docker-compose \
    --file docker-compose.yml \
    --env-file ./env \
    --project-name opensim-${OS_CONFIG} \
    up \
    --detach
