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

# if configuration files are external to the container, run the configuration
if [[ -z "$OS_DOCKER_CONTAINER_CONFIG" ]] ; then
    echo "opensim-docker: running configuration file initialization"
    config/scripts/updateConfigFiles.sh
    config/scripts/linkInConfigs.sh
else
    echo "opensim-docker: delaying configuration file initialization to configuration start"
    # Just set the configuration variables into the environment
    source config/scripts/setEnvironment.sh
fi

# Use the generic docker-compose file or the one specific to the configuration if it exists
cd "$BASE"
COMPOSEFILE="config/config-${CONFIG_NAME}/docker-compose.yml"
if [[ -z "$OS_DOCKER_CONTAINER_CONFIG" ]] ; then
    # if using external configuration, include docker-compose with the mount
    COMPOSEFILE="config/config-${CONFIG_NAME}/docker-compose-external-config.yml"
fi

# Local directory for storage of sql persistant data (so region
#    contents persists between container restarts).
# This must be the same directory as in config-$CONFIG_NAME/docker-compose.yml.
if [[ ! -d "$HOME/opensim-sql-data" ]] ; then
    mkdir -p "$HOME/opensim-sql-data"
    chmod o+w "$HOME/opensim-sql-data"
fi

docker-compose \
    --file "$COMPOSEFILE" \
    --project-name opensim-herbal3d \
    --project-directory "$BASE" \
    up \
    --detach
