#! /bin/bash
# Runs the simulators with screen

export OPENSIMHOME=${OPENSIMHOME:-/home/opensim}
export OPENSIMBIN=${OPENSIMBIN:-/home/opensim/opensim/bin}
export OPENSIMCONFIG=${OPENSIMCONFIG:-$OPENSIMBIN/config}

# Check for disable flag
if [[ -e "${OPENSIMHOME}/NOOPENSIM" ]] ; then
	exit 5
fi

cd "$OPENSIMBIN"

# If this configuration has stuff to do...
# This sets environment variables needed for running OpenSim (See Includes.ini)
if [[ -e "$OPENSIMCONFIG/setup.sh" ]] ; then
    source $OPENSIMCONFIG/setup.sh
fi

cd "$OPENSIMBIN"

rm -f screenlog.0
rm -f *.log

# Start the simulator
# The configuration will read all .ini files from bin/config/.
# ALL other .ini files have been blanked so this is the ONLY configuration
# Simulator is run under 'screen'. Connect to console with "screen -r OpenSimScreen".
screen -L -S OpenSimScreen -p - -d -m dotnet OpenSim.dll -console=basic

# if logConfig is specified, expects to read Nini XML configuration
# -logConfig=/home/opensim/config/logConfig.ini
# iniFile is the main configuration file which defaults to "OpenSim.ini"
# -iniFile=/home/opensim/config/iniFile.ini \
# All .ini and .xml files are read from this directory
# -iniDirectory=/home/opensim/config
