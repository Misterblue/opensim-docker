#! /bin/bash
# Script that copies the Includes.ini into the 'bin/config' dir so
#    OpenSimulator finds our new configuration system.

OPENSIMBIN=${OPENSIMBIN:-/home/opensim/opensim/bin}
OPENSIMCONFIG="$OPENSIMBIN/config"

CONFIG_NAME=${CONFIG_NAME:-standalone}

cd "$OPENSIMCONFIG"
if [[ ! -e "Includes.ini" ]] ; then
    echo "opensim-docker: Copying Includes.ini into bin/config"
    cp "config-${CONFIG_NAME}/Includes.ini" .
fi
