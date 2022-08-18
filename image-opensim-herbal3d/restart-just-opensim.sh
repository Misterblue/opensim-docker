#! /bin/bash
# Stop the running opensimulator

BASE=$(pwd)

export CONFIG_NAME=${CONFIG_NAME:-standalone}

# This export fakes out the environment setup script to look for files in
#    build environment rather than in run environment.
export OPENSIMBIN=$BASE
source config/scripts/setEnvironment.sh
unset OPENSIMBIN

# Use the generic docker-compose file or the one specific to the configuration if it exists
cd "$BASE"
COMPOSEFILE="config/config-${CONFIG_NAME}/docker-compose.yml"
if [[ -z "$OS_DOCKER_CONTAINER_CONFIG" ]] ; then
    # if using external configuration, include docker-compose with the mount
    COMPOSEFILE="config/config-${CONFIG_NAME}/docker-compose-external-config.yml"
fi


echo "Restarting configuration $CONFIG_NAME from \"$COMPOSEFILE\""

docker-compose \
    --file "$COMPOSEFILE" \
    --project-name opensim-${CONFIG_NAME} \
    restart -t 10 opensim
