#! /bin/bash
# Run the first time to setup the environment for OpenSimulator control
OPENSIMHOME=${OPENSIMHOME:-/home/opensim}
OPENSIMBIN=${OPENSIMBIN:-$OPENSIMHOME/opensim/bin}

# Setup the crontab entry for this account so OpenSim stays running
crontab "${OPENSIMHOME}/crontab"
