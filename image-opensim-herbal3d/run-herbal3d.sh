#! /bin/bash
# Run the herbal3d configuration.

# Since the initial run has to create and initialize the MYSQL database
#    the first time, this sets the passwords into the environment before
#    running things.

# Be sure to set environment variables:
#    CONFIGKEY=passwordForCryptFile (optional. Not needed if os-secrets is not ccrypt'ed)
#    CONFIG_NAME=nameOfRunConfiguration (default 'standalone' of not supplied)
#    EXTERNAL_HOSTNAME=IPorDNSnameForSimulator

# If this environment variable is defined, the configuration files are updated with
#    configuration values in the container (at container runtime). Otherwise, the
#    configuration files are updated with values external to the container (in the
#    filesystem of the invoker and the internal directory 'bin/config/ is mounted
#    as the local 'config' directory.
# export OS_DOCKER_CONTAINER_CONFIG="yes"

BASE=$(pwd)

if [[ -z "$EXTERNAL_HOSTNAME" ]] ; then
    echo "Environment variable EXTERNAL_HOSTNAME is not set."
    echo "NOT STARTING!"
    exit 3
fi

export CONFIGKEY=$CONFIGKEY
export EXTERNAL_HOSTNAME=$EXTERNAL_HOSTNAME
export CONFIG_NAME=${CONFIG_NAME:-standalone}

# This export fakes out the environment setup script to look for files in
#    build environment rather than in run environment.
export OPENSIMBIN=$BASE

# set all environment variables
echo "Setting environment vars"
cd "$BASE"
source config/scripts/setEnvironment.sh
# echo "================================"
# env | sort
# echo "================================"

# if configuration files are external to the container, run the configuration
if [[ -z "$OS_DOCKER_CONTAINER_CONFIG" ]] ; then
    echo "opensim-docker: running configuration file initialization"
    cd "$BASE"
    config/scripts/updateConfigFiles.sh
    config/scripts/linkInConfigs.sh
fi

# Use the generic docker-compose file or the one specific to the configuration if it exists
cd "$BASE"
COMPOSEFILE="config/config-${CONFIG_NAME}/docker-compose.yml"
if [[ -z "$OS_DOCKER_CONTAINER_CONFIG" ]] ; then
    # if using external configuration, include docker-compose with the mount
    COMPOSEFILE="config/config-${CONFIG_NAME}/docker-compose-external-config.yml"
fi
echo "Docker-compose file: ${COMPOSEFILE}"

# Local directory for storage of sql persistant data (so region
#    contents persists between container restarts).
# This must be the same directory as in config-$CONFIG_NAME/docker-compose.yml.
if [[ ! -d "$HOME/opensim-sql-data" ]] ; then
    echo "Directory \"$HOME\opensim-sql-data\" does not exist. Creating same."
    mkdir -p "$HOME/opensim-sql-data"
    chmod o+w "$HOME/opensim-sql-data"
fi

# https://docs.docker.com/engine/security/userns-remap/
# --userns-remap="opensim:opensim"
docker compose \
    --file "$COMPOSEFILE" \
    --project-name opensim-${CONFIG_NAME} \
    --project-directory "$BASE" \
    up \
    --detach
