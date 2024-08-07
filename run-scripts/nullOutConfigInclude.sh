#! /bin/bash
# This file is run for initial configuration and is not run thereafter.

# Script that walks ./config-include and over-writes all INI files with empty contents.
# This also creates empty INI files for all the *.example files.

OPENSIMDIR=${OPENSIMDIR:-/home/opensim/opensim}
OPENSIMBIN=${OPENSIMBIN:-$OPENSIMDIR/bin}

cd "$OPENSIMBIN"

if [[ ! -d "./config-include" ]] ; then
    echo "./config-include directory DOES NOT EXIST in the current directory"
    echo "NOT DOING ANYTHING"
    exit 5
fi

TEMPFILE=/tmp/configInclude$$
rm -f "$TEMPFILE"
cat > "$TEMPFILE" << EOFFFF
; This file exists because this file is the default architecture include
;     in OpenSim.ini.
; Look for the real configuration in the mounted config directory.
EOFFFF

for iniFile in $(find ./config-include -name \*.ini ) ; do
    cp "$TEMPFILE" "$iniFile"
done

# this finds all .example files and creates an empty .ini file from that name
for exampleFile in $(find ./config-include -name \*.example) ; do
    cp "$TEMPFILE" "${exampleFile%%.example}"
done

rm -f "$TEMPFILE"
