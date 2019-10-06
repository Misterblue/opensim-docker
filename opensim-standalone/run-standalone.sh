#! /bin/bash
# Run the standalone configuration.

# Since the initial run has to create and initialize the MYSQL database
#    the first time, this sets the passwords into the environment before
#    running things.

# Be sure to set environment variables:
#    CONFIGKEY=passwordForCryptFile
#    CONFIG_NAME=nameOfRunConfiguration (default 'standalone' of not supplied)
#    EXTERNAL_HOSTNAME=IPorDNSnameForSimulator

BASE=$(pwd)

if [[ -z "$CONFIGKEY" ]] ; then
    echo "Configuration password environment variable CONFIGKEY is not set."
    echo "NOT STARTING!"
    exit 3
fi
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

cd "$BASE"
COMPOSEFILE=./docker-compose.yml
if [[ -e "config/$CONFIG_NAME/docker-compose.yml" ]] ; then
    COMPOSEFILE="config/$CONFIG_NAME/docker-compose.yml"
fi

docker-compose \
    --file "$COMPOSEFILE" \
    --project-name opensim-standalone \
    --project-directory "$BASE" \
    up \
    -d \
    opensim
