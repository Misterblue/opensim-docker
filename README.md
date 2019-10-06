# OpenSimulator on Docker

Various configuration files and setups for running [OpenSimulator] in
[Docker] containers. The model builds a Docker image of [OpenSimulator]
and then that image can be run with different configurations (standalone,
grid, ...).

There are two possible images: `opensim-standalone` which is straight [OpenSimulator]
'master' branch, and `opensim-herbal3d` which is [OpenSimulator] built with
the [Herbal3d] addon modules. These base images can have different runtime
configurations which includes running with a seperate [Docker] container for
the database (uses [MariaDB]) and/or different [OpenSimulator] configuration
files.

As an example, to create a standalone version that creates two containers
(simulator and database):

```
# Get these configuration files
cd
git clone https://github.com/Misterblue/opensim-docker.git

# Use the standalone setup for this example
cd opensim-docker/opensim-standalone

# Select the runtime configuration to use
export CONFIG_NAME=standalone-mysql

# Create secrets
cd config/$CONFIG_NAME
cp ../os-secrets tmpfile
# Edit 'tmpfile' with secrets (MYSQL root password, etc)
ccrypt -e -K secretPassword < tmpfile > os-secrets.crypt
rm tmpfile

# Do any additional OpenSimulator configuration
# Edit 'config/$CONFIG_NAME/Regions/Regions.ini for region location
# Edit 'config/$CONFIG_NAME/misc.ini for other settings
# Edit 'config'$CONFIG_NAME/config-include/*.ini for grid connections

# Build OpenSimulator image
cd
cd opensim-docker/opensim-standalone
./build-standalone.sh

# Run the composed container set
CONFIG_NAME=standalone-mysql CONFIGKEY=secretPassword EXTERNAL_HOSTNAME=whateverTheHostnameIs ./run-standalone.sh
```

As of October 2019, these [Docker] images have not been built and uploaded
anywhere as you will probably want to be using the latest [OpenSimulator]
sources and thus require a fresh build.

## Image Configuration

The `Dockerfile`s setup the image with a few scripts to configure and start
[OpenSimulator], periodically check for crashes, copy crash'ed log files,
and restart the simulator if it's not running.

The container starts the script `/home/opensim/bootOpenSim.sh` which runs
configuration scripts and then starts the simulator. There are other scripts
to do setup (`firstTimeSetup.sh`), capture crash information (`captureCrash.sh`),
or to start the simulator (`run.opensim.sh`). 

The simulator runs as the created user account `opensim` for a little security.

The `README` files in the sub-directories contain instructions on setup
of these configuration files and building the images. There are scripts
for building the images (e.g., `build-standalone.sh`) and then running
the images with `docker-compose` (e.g., `run-standalone.sh`).

## OpenSimulator Configuration

The biggest problem with Docker'izing [OpenSimulator] is the configuration
file setup -- [OpenSimulator] has manual setup and configuration files
scattered around. Add to that the radically different runtime setups possible
(stand-alone with or without databases and grid hosting or grid connected)
and a generalized, containerable configuration becomes difficult.

The solution used here is to mostly null out the configuration that comes
with the base [OpenSimulator] sources and to replace them with copies in
a separate directory. In general,

- `OpenSimDefaults.ini` is used unchanged from  the sources
- `OpenSim.ini.example` is copied to `OpenSim.ini` with no changes
- the files in `config-include` are emptied so they don't do anything when included by any script
- configuration uses the feature that [OpenSimulator] reads all the INI files in `bin/config`

The latter feature means that one could either use the configuration samples included
with these sources or one could mount a volume on top of `/home/opensim/opensim/bin/config`
and completely replace all the configuration files. This enables the flexibility
of either building configuration within the [Docker] image or supplying one's
own configuration at runtime.

[OpenSimulator]: https://opensimulator.org
[Docker]: https://www.docker.com
[Herbal3d]: https://www.herbal3d.org
[MariaDB]: https://mariadb.org/

