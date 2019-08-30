#! /bin/bash
# Runs the simulators with screen
cd /home/opensim
cd opensim/bin

rm -f screenlog.0
rm -f *.log

export MONO_THREADS_PER_CPU=100
# parameters suggested by Ubit (20170526)
ulimit -s 262144
export MONO_GC_PARAMS="soft-heap-limit=1280m,minor=split,promotion-age=14"
export MONO_ENV_OPTIONS="--desktop"

screen -L -S OpenSimScreen -p - -d -m mono OpenSim.exe -console=basic
# screen -L -S OpenSimScreen -p - -d -m mono --profile=log:sample=cycles/100 OpenSim.exe -console=basic
# screen -L -S OpenSimScreen -p - -d -m mono --profile=log:sample=instr/100 OpenSim.exe -console=basic
# screen -L -S OpenSimScreen -p - -d -m mono --profile=log:noalloc,calls,maxframes=4 OpenSim.exe -console=basic

# To analyze:
# mprof-report --traces output.mlpd > /tmp/frog2
# mprof-report --reports=sample output.mlpd
# mprof-report --reports=sample --verbose output.mlpd
# mprof-report --reports=call --verbose output.mlpd

