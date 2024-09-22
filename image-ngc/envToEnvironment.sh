#! bin/bash
# The ./env file is formatted for docker-compose
# This script outputs a conversion of that file with
#     'export' added to each line so it can be set into
#    a Bash environment.

TEMPFILE=/tmp/envToEnvironment$$
sed -e 's/^\([A-Z]\)/export \1/' < ./env > "$TEMPFILE"
source "$TEMPFILE"
rm -f "$TEMPFILE"
