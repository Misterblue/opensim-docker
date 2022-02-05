#! /bin/bash
# Script run when the container starts and before OpenSimulator is started
#
# The operations done here are:
#   -- if first time called, setup DB and initialize variables in configuration files
#   -- move sub-config specific Includes.ini into the config directory
#   -- update all the configuration files with environment variables

export OPENSIMBIN=${OPENSIMBIN:-/home/opensim/opensim/bin}
export CONFIGDIR=${CONFIGDIR:-$OPENSIMBIN/config}

echo "opensim-docker: setup.sh: CONFIGDIR=\"${CONFIGDIR}\""

FIRSTTIMEFLAG=${CONFIGDIR}/.configFirstTime

cd "$CONFIGDIR"
# This sets CONFIG_NAME which is the configuration subdirectory (like standalone)
source ./scripts/setEnvironment.sh

# If this is the first time run, do database setup and some one-time configuration updates
if [[ ! -e "$FIRSTTIMEFLAG" ]] ; then
    echo "opensim-docker: setup.sh: first time"
    cd "$CONFIGDIR"
    # Do any database account and db creation
    ./scripts/initializeDb.sh
    touch "$FIRSTTIMEFLAG"
fi

# Move the configuration include file into place
# This makes opensim/bin/config directory contain this INI file for this image/config
# Since all the regular configuration has been nulled out, this will be the only config
#    after bin/OpenSimDefaults.ini and bin/OpenSim.ini
cd "$CONFIGDIR"
if [[ -e "config-${CONFIG_NAME}/Includes.ini" ]] ; then
    echo "opensim-docker: setup.sh: Copying \"${CONFIG_NAME}/Includes.ini\""
    cp "config-${CONFIG_NAME}/Includes.ini" .
fi

echo "opensim-docker: setup.sh: CONFIG_NAME=${CONFIG_NAME}"

# Do any update to configuration files that happens each start
# This updates bin/OpenSim.ini and Regions/*.ini with needed values
cd "$CONFIGDIR"
./scripts/updateConfigFiles.sh

