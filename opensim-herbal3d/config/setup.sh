#! /bin/bash
# Script run when the container starts and before OpenSimulator is started

OPENSIMBIN=${OPENSIMBIN:-/home/opensim/opensim/bin}
CONFIGDIR=${CONFIGDIR:-$OPENSIMBIN/config}

FIRSTTIMEFLAG=${CONFIGDIR}/.configFirstTime

cd "$CONFIGDIR"
# This sets CONFIG_NAME which is the configuration subdirectory (like docker-standalone)
source ./scripts/setEnvironment.sh

if [[ ! -e "$FIRSTTIMEFLAG" ]] ; then
    cd "$CONFIGDIR"
    # Do any database account and db creation
    ./scripts/initializeDb.sh
    # Add environment variables to configuration files
    ./scripts/initializeConfig.sh
    # Remember we've done this
    touch "$FIRSTTIMEFLAG"
fi

# Move the configuration include file into place
cd "$CONFIGDIR"
if [[ -e "${CONFIG_NAME}/Includes.ini" ]] ; then
    cp "${CONFIG_NAME}/Includes.ini" .
fi

# Do any update to configuration files that happens each start
cd "$CONFIGDIR"
./scripts/updateConfigFiles.sh

