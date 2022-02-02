#! /bin/bash
# Run when booting the Docker file.
# Checks to see if this is the very first time in which case it
#    runs the first time setup. Otherwise it just sets things running.

export OPENSIMHOME=/home/opensim
export VERSIONDIR=$OPENSIMHOME/VERSION
export OPENSIMBIN=$OPENSIMHOME/opensim/bin
export OPENSIMCONFIG=$OPENSIMBIN/config

FIRSTTIMEFLAG=$OPENSIMHOME/.firstTimeFlag

# Some setup environment variables should have been set
for requiredEnv in "CONFIGKEY" "EXTERNAL_HOSTNAME" ; do
    if [[ -z "${!requiredEnv}" ]] ; then
        echo "Environment variable $requiredEnv is not set"
        exit 5
    fi
done

# If this configuration has stuff to do...
if [[ -e "$OPENSIMCONFIG/setup.sh" ]] ; then
    $OPENSIMCONFIG/setup.sh
fi

if [[ ! -e "$FIRSTTIMEFLAG" ]] ; then
    # First time setup for the OpenSim running and crash checking scripts
    cd "$OPENSIMHOME"
    ./firstTimeSetup.sh
    touch "$FIRSTTIMEFLAG"
    rm -f NOOPENSIM
fi

# Start Opensim
echo "Starting OpenSimulator version $(cat $VERSIONDIR/OS_VERSION)"
echo "   with opensim-docker version $(cat $VERSIONDIR/OS_DOCKER_IMAGE_VERSION)"
echo "   using configuration set \"$CONFIG_NAME\""

cd "$OPENSIMHOME"
./run.opensim.sh
while true ; do
    sleep 300
    ./checkOpenSim.sh
done
