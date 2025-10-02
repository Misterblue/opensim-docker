#! /bin/bash
# Script that sets up the environment variables
# This script is run before the docker-compose file is run to get the
#     database password and it is run when the opensim Docker container starts
#     to get all the values for the configuration files.

OPENSIMBIN=${OPENSIMBIN:-/home/opensim/opensim/bin}
OPENSIMCONFIG=${OPENSIMCONFIG:-$OPENSIMBIN/config}

cd "$OPENSIMCONFIG"

# See if we have encrypted secrets
unset HAVE_SECRETS
if [[ ! -z "$OS_CONFIGKEY" ]] ; then
    for secretsFile in $OPENSIMCONFIG/os-secrets.crypt ; do
        if [[ -e "$secretsFile" ]] ; then
            echo "opensim-docker: setEnvironment.sh: have secrets file \"{$secretsFile}\""
            # export key for ccrypt - otherwise it fails
            export OS_CONFIGKEY=$OS_CONFIGKEY;
            source <(ccrypt -c -E OS_CONFIGKEY "$secretsFile")
            # unset the key again
            unset OS_CONFIGKEY;
            HAVE_SECRETS=yes
            break;
        else
            echo "opensim-docker: setEnvironment.sh: no encrypted secrets file"
        fi
    done
fi

# If no encrypted secrets, maybe unsecure plain-text secrets are available
if [[ -z "$HAVE_SECRETS" ]] ; then
    echo "opensim-docker: setEnvironment.sh: trying plain text secrets"
    for secretsFile in $OPENSIMCONFIG/os-secrets ; do
        if [[ -e "$secretsFile" ]] ; then
            echo "opensim-docker: setEnvironment.sh: plain text secrets from \"${secretsFile}\""
            source "$secretsFile"
            break;
        else
            echo "opensim-docker: setEnvironment.sh: no plain text secrets file"
        fi
    done
fi
