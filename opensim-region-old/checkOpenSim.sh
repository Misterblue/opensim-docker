#! /bin/bash
# Check to see if OpenSim is running and restart if it is not

BASE=/home/opensim

CRASHLOG=${BASE}/crashlog.log
HDR="$(date +%Y%m%d%H%M):"

LASTCRASH=${BASE}/.lastCrash
TIMEAGO=${BASE}/.lastTimeAgo

cd

if [[ -e "${BASE}/NOOPENSIM" ]] ; then
	exit 5
fi

flag=$(ps -efa | grep SCREEN | grep OpenSimScreen)

if [[ -z "$flag" ]] ; then
	echo "$HDR Found crashed OpenSim regions"
	rm -f $TIMEAGO
	touch --date="-1 hours" $TIMEAGO
	if [[ ! -e $LASTCRASH || $TIMEAGO -nt $LASTCRASH ]] ; then
		echo "$HDR Capturing OpenSim crash"
		${BASE}/captureCrash.sh
		rm -f $LASTCRASH
		touch $LASTCRASH
	fi
	echo "$HDR Restarting OpenSim regions"
	${BASE}/run.opensim.sh
fi >> $CRASHLOG
