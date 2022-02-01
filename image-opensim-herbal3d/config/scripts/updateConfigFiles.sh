#! /bin/bash
# Before running OpenSimulator, we update the configuration files
# for the current running environment.
# This is run before every OpenSimulator run to update changing parameters.

OPENSIMBIN=${OPENSIMBIN:-/home/opensim/opensim/bin}
CONFIGDIR=${CONFIGDIR:-$OPENSIMBIN/config}

cd "$CONFIGDIR"
source ./scripts/setEnvironment.sh

# Update EXTERNAL_HOSTNAME
cd "$OPENSIMBIN"
for file in $OPENSIMBIN/Regions/*.ini $CONFIGDIR/$CONFIG_NAME/Regions/*.ini ; do
    if [[ -e "$file" ]] ; then
        sed --in-place -e "s/^ExternalHostName = .*$/ExternalHostName = \"${EXTERNAL_HOSTNAME}\"/" "$file"
    fi
done

sed --in-place -e "s/^ *BaseHostname = .*$/  BaseHostname = ${EXTERNAL_HOSTNAME}/" "$OPENSIMBIN/OpenSim.ini"
