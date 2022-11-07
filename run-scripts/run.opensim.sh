#! /bin/bash
# Runs the simulators with screen

OPENSIMBIN=${OPENSIMBIN:-/home/opensim/opensim/bin}
cd "$OPENSIMBIN"

rm -f screenlog.0
rm -f *.log

screen -L -S OpenSimScreen -p - -d -m ./OpenSim -console=basic
