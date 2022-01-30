#! /bin/bash
# Script that sets up the environment variables

OPENSIMBIN=${OPENSIMBIN:-/home/opensim/opensim/bin}

OPENSIMCONFIG="$OPENSIMBIN/config"
cd "$OPENSIMCONFIG"

if [[ -e "./os-config" ]] ; then
    source ./os-config
else
    CONFIG_NAME=standalone
fi

# See if we have encrypted secrets
unset HAVE_SECRETS
if [[ ! -z "$CONFIGKEY" ]] ; then
    for secretsFile in $OPENSIMCONFIG/$CONFIG_NAME/os-secrets.crypt $OPENSIMCONFIG/os-secrets.crypt ; do
        if [[ -e "$secretsFile" ]] ; then
            source <(ccrypt -c -E CONFIGKEY "$secretsFile")
            HAVE_SECRETS=yes
            break;
        fi
    done
fi

# If no encrypted secrets, maybe unsecure plain-text secrets are available
if [[ -z "$HAVE_SECRETS" ]] ; then
    for secretsFile in $OPENSIMCONFIG/$CONFIG_NAME/os-secrets $OPENSIMCONFIG/os-secrets ; do
        if [[ -e "$secretsFile" ]] ; then
            source "$secretsFile"
            break;
        fi
    done
fi
