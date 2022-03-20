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
COMPOSEFILE=./docker-compose.yml
if [[ -e "config/config-${CONFIG_NAME}/docker-compose.yml" ]] ; then
    COMPOSEFILE="config/config-${CONFIG_NAME}/docker-compose.yml"
fi

echo "Stopping configuration $CONFIG_NAME from \"$COMPOSEFILE\""

docker-compose \
    --file "$COMPOSEFILE" \
    --project-name opensim-standalone \
    down
