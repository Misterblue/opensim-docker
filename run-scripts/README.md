This directory of files are copied into /home/opensim to act as the
startup and operation scripts for the instance of OpenSim that is running
in the docker container.

These scripts all run inside the container to control the running of
the OpenSimulator simulator. The scripts for controlling the container
(like starting and stopping the container from the command line) refer
to the image-* directory.

`bootOpenSim.sh` is run when the docker container starts and is responsible
for seeing that the configuration files and other setup (like DB) are initialized.
This script calls `firstTimeSetup.sh` for the first ever boot to do any
initial setup.
This script will fail if the environment variables `OS_CONFIGKEY` or `EXTERNAL_HOSTNAME`
are not set.

`run.opensim.sh` starts the OpenSimulator instance.

`checkOpenSim.sh` is run periodically to make sure that the OpenSimulator instance
is running and, if not, save crash information (`captureCrash.sh`) and then
restart OpenSimulator.

`crontab` is set initially to run `checkOldLogFiles.sh` which rotates `OpenSim.log`.
