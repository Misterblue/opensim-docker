#! /bin/bash
# Script to create database 'opensim' in mysql if it does not exist.
# This is usually run in the container on the first time it is invoked.
# This creates the database for this simulator (MYSQL_DB_HOST) if it
#   doesn't exist.
#
# Someone has set the environment variables before running this.
# Needs:
#       MYSQL_ROOT_PASSWORD
#       MYSQL_DB_HOST
#       MYSQL_DB_DB
#       MYSQL_DB_USER
#       MYSQL_DB_USER_PW

OPENSIMBIN=${OPENSIMBIN:-/home/opensim/opensim/bin}
OPENSIMCONFIG=${OPENSIMCONFIG:-$OPENSIMBIN/config}

echo "opensim-docker: initializeDb.sh: "

cd "$OPENSIMCONFIG"

if [[ ! -z "$MYSQL_ROOT_PASSWORD" ]] ; then
    for needed in "MYSQL_DB_DB" "MYSQL_DB_HOST" "MYSQL_DB_USER" "MYSQL_DB_USER_PW" ; do
        if [[ -z "$!needed" ]] ; then
            echo "opensim-docker: initializeDb.sh: missing required env parameter $needed"
            echo "opensim-docker: initializeDb.sh: DATABASE NOT INITIALIZED"
            exit 5
        fi
    done

    SQLCMDS=/tmp/mymy$$
    SQLOPTIONS=/tmp/mymyoptions$$
    rm -f "$SQLCMDS"
    rm -f "$SQLOPTIONS"

    # Create command file that creates the SQL database and SQL user for this simulator.
    cat > "$SQLCMDS" <<EOFFFF
CREATE DATABASE $MYSQL_DB_DB;
USE $MYSQL_DB_DB;
CREATE USER '$MYSQL_DB_USER'@'%' IDENTIFIED BY '$MYSQL_DB_USER_PW';
GRANT ALL ON $MYSQL_DB_DB.* to '$MYSQL_DB_USER'@'%';
quit
EOFFFF
    cat > "$SQLOPTIONS" <<EOFFFF
[client]
user=root
password=$MYSQL_ROOT_PASSWORD
host=$MYSQL_DB_HOST
EOFFFF

    # If the database is started at the same time, what for it to initialize
    until mysql --defaults-extra-file=$SQLOPTIONS -e "show databases" ; do
        echo "opensim-docker: initializeDb.sh: Waiting on database to be ready"
        sleep 2
    done
    echo "opensim-docker: initializeDb.sh: Database is ready"


    HASDB=$(mysql --defaults-extra-file=$SQLOPTIONS -e "show databases" | grep "^${MYSQL_DB_DB}$")

    if [[ -z "$HASDB" ]] ; then
        echo "opensim-docker: initialzeDb.sh: creating opensim database"
        mysql --defaults-extra-file=$SQLOPTIONS < "$SQLCMDS"
    else
        echo "opensim-docker: initialzeDb.sh: opensim database has already been created"
    fi

    rm -f "$SQLCMDS"
    rm -f "$SQLOPTIONS"
else
    echo "opensim-docker: initializeDb.sh: Not configuring SQL database"
fi

