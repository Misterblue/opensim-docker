#! /bin/bash
# Check to see if OpenSim is running and restart if it is not

export OPENSIMHOME=${OPENSIMHOME:-/home/opensim}
export OPENSIMBIN=${OPENSIMBIN:-/home/opensim/opensim/bin}

CRASHLOG=${OPENSIMHOME}/crashlog.log
HDR="$(date +%Y%m%d%H%M):"

LASTCRASH=${OPENSIMHOME}/.lastCrash
TIMEAGO=${OPENSIMHOME}/.lastTimeAgo

if [[ -e "${OPENSIMHOME}/NOOPENSIM" ]] ; then
	exit 5
fi

flag=$(ps -efa | grep SCREEN | grep OpenSimScreen)

if [[ -z "$flag" ]] ; then
	echo "$HDR Found crashed OpenSim regions"
	rm -f $TIMEAGO
    # If crashed last time, don't keep restarting over and over.
	touch --date="-1 hours" $TIMEAGO
	if [[ ! -e $LASTCRASH || $TIMEAGO -nt $LASTCRASH ]] ; then
		echo "$HDR Capturing OpenSim crash"
		${OPENSIMHOME}/captureCrash.sh
		rm -f $LASTCRASH
		touch $LASTCRASH
	fi
	echo "$HDR Restarting OpenSim regions"
	${OPENSIMHOME}/run.opensim.sh
fi >> $CRASHLOG
