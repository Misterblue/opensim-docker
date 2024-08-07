#! /bin/bash
# Script run when the container starts and before OpenSimulator is started
#
# The operations done here are:
#   -- if first time called, setup DB and initialize variables in configuration files
#   -- move sub-config specific Includes.ini into the config directory
#   -- update all the configuration files with environment variables

export OPENSIMBIN=${OPENSIMBIN:-/home/opensim/opensim/bin}
export OPENSIMCONFIG=${OPENSIMCONFIG:-$OPENSIMBIN/config}

echo "opensim-docker: setup.sh: OPENSIMCONFIG=\"${OPENSIMCONFIG}\""

FIRSTTIMEFLAG=${HOME}/.configFirstTime

cd "$OPENSIMCONFIG"
# This sets CONFIG_NAME which is the configuration subdirectory (like standalone)
source ./scripts/setEnvironment.sh

# If this is the first time run, do database setup and some one-time configuration updates
if [[ ! -e "$FIRSTTIMEFLAG" ]] ; then
    echo "opensim-docker: setup.sh: first time"
    cd "$OPENSIMCONFIG"
    # Do any database account and db creation
    ./scripts/initializeDb.sh
    touch "$FIRSTTIMEFLAG"
fi

