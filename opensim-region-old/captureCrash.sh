#! /bin/bash
# Copy physics logs from usual physics log directory into
#   a subdirectory of the log dir so they won't get deleted.
# Also saves the OpenSimulator log and screen files in subdir.

DATETAG=$1

BASE=/home/opensim

if [[ -z "$DATETAG" ]] ; then
	DATETAG=$(date +%Y%m%d.%H%M)
fi

RUNDIR=$BASE/opensim/bin
LOGDIR=$BASE/logs
SAVEDIR=$LOGDIR/$DATETAG

echo "Capturing crash from $RUNDIR into $SAVEDIR"

mkdir -p $SAVEDIR

cd $LOGDIR
mv phys*.log $SAVEDIR
mv $RUNDIR/screenlog.0 $SAVEDIR
mv $RUNDIR/OpenSim.log $SAVEDIR


