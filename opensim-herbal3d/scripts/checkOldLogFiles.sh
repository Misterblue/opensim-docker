#! /bin/bash
# Clean out old log files in the log directory.
# Does not delete saved log directories.

OPENSIMHOME=${OPENSIMHOME:-/home/opensim}

TIMEAGO=${OPENSIMHOME}/.lastLogCleanup

LOGDIR="${OPENSIMHOME}/logs"
if [[ -d "$LOGDIR" ]] ; then
    rm -f "$TIMEAGO"
    touch --date="-1 hours" "$TIMEAGO"

    cd "$LOGDIR"
    for file in phys*.log scene-*.log ; do
        if [[ -e "$file" ]] ; then
            if [[ $TIMEAGO -nt "$file" ]] ; then
                rm -f "$file"
            fi
        fi
    done
fi
