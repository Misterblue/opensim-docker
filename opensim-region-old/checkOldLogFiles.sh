#! /bin/bash
# Clean out old log files in the log directory.
# Does not delete saved log directories.

BASE=/home/opensim

TIMEAGO=${BASE}/.lastLogCleanup

cd "${BASE}/logs"

rm -f "$TIMEAGO"
touch --date="-1 hours" "$TIMEAGO"

for file in $(ls phys*.log scene-*.log ) ; do
    if [[ $TIMEAGO -nt "$file" ]] ; then
        rm -f "$file"
    fi
done
