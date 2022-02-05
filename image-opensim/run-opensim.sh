#! /bin/bash
# Run the default Docker image using the standalone configuration.

# Since the initial run has to create and initialize the MYSQL database
#    the first time, this sets the passwords into the environment before
#    running things.

# Be sure to set environment variables:
#    CONFIGKEY=passwordForCryptFile (optional. Not needed if os-secrets is not ccrypt'ed)
#    CONFIG_NAME=nameOfRunConfiguration (default 'standalone' of not supplied)
#    EXTERNAL_HOSTNAME=IPorDNSnameForSimulator

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
source config/scripts/setEnvironment.sh
unset OPENSIMBIN

# Use the generic docker-compose file or the one specific to the configuration if it exists
cd "$BASE"
COMPOSEFILE=./docker-compose.yml
if [[ -e "config/$CONFIG_NAME/docker-compose.yml" ]] ; then
    COMPOSEFILE="config/$CONFIG_NAME/docker-compose.yml"
fi

# Local directory for storage of sql persistant data (so region
#    contents persists between container restarts).
# This must be the same directory as in $CONFIG_NAME/docker-compose.yml.
if [[ ! -d "$HOME/opensim-sql-data" ]] ; then
    mkdir -p "$HOME/opensim-sql-data"
    chmod o+w "$HOME/opensim-sql-data"
fi

docker-compose \
    --file "$COMPOSEFILE" \
    --project-name opensim-standalone \
    --project-directory "$BASE" \
    up \
    --detach
