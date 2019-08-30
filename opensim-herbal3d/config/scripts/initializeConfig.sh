#! /bin/bash
# Script that mangles OpenSim configuration files with the necessary data.
# Someone has set the environment variables before running this.
# Needs:
#       OPENSIM_DB_PASSWORD
#       DEFAULT_ESTATE_NAME
#       DEFAULT_ESTATE_OWNER
#       DEFAULT_ESTATE_OWNER_PASSWORD

OPENSIMBIN=${OPENSIMBIN:-/home/opensim/opensim/bin/}
CONFIG_NAME=${CONFIG_NAME:-docker-standalone}

CONFIGDIR=${OPENSIMBIN}/config/${CONFIG_NAME}

sed --in-place \
    -e "s/OPENSIM_DB_PASSWORD/$OPENSIM_DB_PASSWORD/" \
    -e "s/PW_FOR_DEFAULT_ESTATE_OWNER/$PW_FOR_DEFAULT_ESTATE_OWNER/" \
    -e "s/DEFAULT_ESTATE_NAME/$DEFAULT_ESTATE_NAME/" \
    -e "s/DEFAULT_ESTATE_OWNER/$DEFAULT_ESTATE_OWNER/" \
    "${CONFIGDIR}/misc.ini"


