#! /bin/bash
# Run when booting the Docker file.
# Checks to see if this is the very first time in which case it
#    runs the first time setup. Otherwise it just sets things running.

# The environment variable CONFIG_NAME can be set here otherwise
#    the value in config/os-config is used
# If os-secrets.crypt exists in the configuration, the environment
#    variable CONFIGKEY must exist and be the password for the encrypted file

export OPENSIMHOME=/home/opensim
export VERSIONDIR=$OPENSIMHOME/VERSION
export OPENSIMBIN=$OPENSIMHOME/opensim/bin
export OPENSIMCONFIG=$OPENSIMBIN/config

# Start Opensim
echo "Starting OpenSimulator version $(cat $VERSIONDIR/OS_VERSION)"
echo "   with opensim-docker version $(cat $VERSIONDIR/OS_DOCKER_IMAGE_VERSION)"
echo "   using configuration set \"$OS_CONFIG\""

cd "$OPENSIMHOME"
./run.opensim.sh

# Wait around here because when this script exits the Docker container exits
while true ; do
    sleep 300
    ./checkOpenSim.sh
done
