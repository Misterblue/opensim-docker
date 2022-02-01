#! /bin/bash
# Copy physics logs from usual physics log directory into
#   a subdirectory of the log dir so they won't get deleted.
# Also saves the OpenSimulator log and screen files in subdir.

DATETAG=$1

OPENSIMHOME=${OPENSIMHOME:-/home/opensim}

if [[ -z "$DATETAG" ]] ; then
	DATETAG=$(date +%Y%m%d.%H%M)
fi

OPENSIMBIN=${OPENSIMBIN:-$OPENSIMHOME/opensim/bin}

LOGDIR=$OPENSIMHOME/logs
SAVEDIR=$LOGDIR/$DATETAG

echo "Capturing crash from $OPENSIMBIN into $SAVEDIR"

mkdir -p $SAVEDIR

cd $LOGDIR
for logfile in phys*.log ; do
    if [[ -e "$logfile" ]] ; then
        mv "$logfile" "$SAVEDIR"
    fi
done
if [[ -e "$OPENSIMBIN/screenlog.0" ]] ; then
    mv $OPENSIMBIN/screenlog.0 $SAVEDIR
fi
if [[ -e "$OPENSIMBIN/OpenSim.log" ]] ; then
    mv $OPENSIMBIN/OpenSim.log $SAVEDIR
fi


