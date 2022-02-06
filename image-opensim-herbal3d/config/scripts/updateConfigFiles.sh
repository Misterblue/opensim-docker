#! /bin/bash
# Before running OpenSimulator, we update the configuration files
# for the current running environment.
# This is run before every OpenSimulator run to update changing parameters.

OPENSIMBIN=${OPENSIMBIN:-/home/opensim/opensim/bin}

# For this image, CONFIG_NAME is the configuration being used
CONFIG_NAME=${CONFIG_NAME:-standalone}
CONFIGDIR=${OPENSIMBIN}/config/config-${CONFIG_NAME}

cd "$CONFIGDIR"
source ../scripts/setEnvironment.sh

# Update EXTERNAL_HOSTNAME
cd "$OPENSIMBIN"
for file in $OPENSIMBIN/Regions/*.ini $CONFIGDIR/Regions/*.ini ; do
    if [[ -e "$file" ]] ; then
        echo "opensim-docker: updateConfigFiles.sh: fixing ExternalHostname in \"$file\""
        sed --in-place -e "s/^ExternalHostName = .*$/ExternalHostName = \"${EXTERNAL_HOSTNAME}\"/" "$file"
    fi
done

# Add EXTERNAL_HOSTNAME to the common configuation in OpenSim.ini
if [[ -e "$OPENSIMBIN/OpenSim.ini" ]] ; then
    sed --in-place -e "s/^ *BaseHostname = .*$/  BaseHostname = ${EXTERNAL_HOSTNAME}/" "$OPENSIMBIN/OpenSim.ini"
    echo "opensim-docker: updateConfigFiles.sh: fixing BaseHostname in OpenSim.ini"
    grep " BaseHostname =" "$OPENSIMBIN/OpenSim.ini"
fi

# If the environment variables haven't been copied into misc.ini, do it now
echo "opensim-docker: updateConfigFiles.sh: replacing vars in \"${CONFIGDIR}/misc.ini\""
# If the replacement has already happened, this is a NOOP
sed --in-place \
    -e "s/MYSQL_DB_USER/$MYSQL_DB_USER/" \
    -e "s/MYSQL_DB_USER_PASSWORD/$MYSQL_DB_USER_PASSWORD/" \
    -e "s/MYSQL_DB_SOURCE/$MYSQL_DB_SOURCE/" \
    -e "s/MYSQL_DB_DB/$MYSQL_DB_DB/" \
    -e "s/PW_FOR_DEFAULT_ESTATE_OWNER/$PW_FOR_DEFAULT_ESTATE_OWNER/" \
    -e "s/DEFAULT_ESTATE_NAME/$DEFAULT_ESTATE_NAME/" \
    -e "s/DEFAULT_ESTATE_OWNER/$DEFAULT_ESTATE_OWNER/" \
    "${CONFIGDIR}/misc.ini"


