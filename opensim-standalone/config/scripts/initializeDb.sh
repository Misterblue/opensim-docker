#! /bin/bash
# Script to create database 'opensim' in mysql if it does not exist.
# Someone has set the environment variables before running this.
# Needs:
#       MYSQL_ROOT_PASSWORD
#       OPENSIM_DB_PASSWORD

OPENSIMBIN=${OPENSIMBIN:-/home/opensim/opensim/bin}
OPENSIMCONFIG=${OPENSIMCONFIG:-$OPENSIMBIN/config}

cd "$OPENSIMCONFIG"

if [[ ! -z "$MYSQL_ROOT_PASSWORD" ]] ; then
    SQLCMDS=${OPENSIMCONFIG}/mymy$$
    SQLOPTIONS=${OPENSIMCONFIG}/mymyoptions$$
    rm -f "$SQLCMDS"
    rm -f "$SQLOPTIONS"

    # If the database is started at the same time, what for it to initialize
    sleep 10

    cat > "$SQLCMDS" <<EOFFFF
CREATE DATABASE opensim;
USE opensim;
CREATE USER 'opensim'@'%' IDENTIFIED BY '$MYSQL_DB_PASSWORD';
GRANT ALL ON opensim.* to 'opensim'@'%';
quit
EOFFFF
    cat > "$SQLOPTIONS" <<EOFFFF
[client]
user=root
password=$MYSQL_ROOT_PASSWORD
host=$MYSQL_DB_SOURCE
EOFFFF

    HASDB=$(mysql --defaults-extra-file=$SQLOPTIONS -e "show databases" | grep "^opensim$")

    if [[ -z "$HASDB" ]] ; then
        echo "creating opensim database"
        mysql --defaults-extra-file=$SQLOPTIONS < "$SQLCMDS"
    else
        echo "opensim database has already been created"
    fi

    rm -f "$SQLCMDS"
    rm -f "$SQLOPTIONS"
else
    echo "Not configuring MYSQL"
fi

