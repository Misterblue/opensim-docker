#! /bin/bash
# Script that mangles OpenSim configuration files with the necessary data.
# Someone has set the environment variables before running this.

OPENSIMBIN=${OPENSIMBIN:-/home/opensim/opensim/bin/}
CONFIG_NAME=${CONFIG_NAME:-docker-standalone}

CONFIGDIR=${OPENSIMBIN}/config/${CONFIG_NAME}

sed --in-place \
    -e "s/MYSQL_DB_USER/$MYSQL_DB_USER/" \
    -e "s/MYSQL_DB_SOURCE/$MYSQL_DB_SOURCE/" \
    -e "s/MYSQL_DB_DB/$MYSQL_DB_DB/" \
    -e "s/MYSQL_DB_PASSWORD/$MYSQL_DB_PASSWORD/" \
    -e "s/PW_FOR_DEFAULT_ESTATE_OWNER/$PW_FOR_DEFAULT_ESTATE_OWNER/" \
    -e "s/DEFAULT_ESTATE_NAME/$DEFAULT_ESTATE_NAME/" \
    -e "s/DEFAULT_ESTATE_OWNER/$DEFAULT_ESTATE_OWNER/" \
    "${CONFIGDIR}/misc.ini"


