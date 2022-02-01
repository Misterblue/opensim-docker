# OpenSimulator on Docker

Various configuration files and setups for running [OpenSimulator] in
[Docker] containers. The model builds a Docker image of [OpenSimulator]
and then that image can be run with different configurations (standalone,
grid, ...).

There was a presentation on this project at the
[OpenSimulator Community Conference 2019](https://conference.opensimulator.org/2019/)
that is available at
[OSCC19 Dockerizing OpenSimulator](https://www.youtube.com/watch?v=-EnTepHqLA4) .

This is organized into building *images* and *config*s for those images.
The model is for one to build a Docker image with one of the [OpenSimulator]
images in it and, at runtime, choose one of the embedded configurations to
run it with. The [OpenSimulator] "image" is a built version of the source
code and the "config" is the collection of INI files that are used to run it.

Two images are currently present: `image-opensim` which is a built of the
straight [OpenSimulator] 'master' branch,
and `image-opensim-herbal3d` which is [OpenSimulator] built with
the [Herbal3d] addon modules.
(Since I'm the Herbal3d main developer, this is how I test it.)

The Docker images are run using `docker-compose` to set up ports
and environment. Additionally, if a database server is needed,
that is also started and linked to the [OpenSimulator] instance.
[MariaDB] is used for the external SQL server.

As an example, to create a standalone version that creates two containers
(simulator and database):

```
# Get these configuration files
cd
git clone https://github.com/Misterblue/opensim-docker.git

# Use the standalone setup for this example
cd opensim-docker/image-opensim

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
cd opensim-docker/image-opensim
./build-opensim.sh

# Run the composed container set
CONFIG_NAME=standalone-mysql CONFIGKEY=secretPassword EXTERNAL_HOSTNAME=whateverTheHostnameIs ./run-standalone.sh
```

As of January 2022, these [Docker] images have not been built and uploaded
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
for building the images (e.g., `build-opensim.sh`) and then running
the images with `docker-compose` (e.g., `run-opensim.sh`).

## OpenSimulator Configuration

The biggest problem with Docker'izing [OpenSimulator] is the configuration
file setup -- [OpenSimulator] has manual setup and configuration files
scattered around. Add to that the radically different runtime setups possible
(standalone with or without databases and grid hosting or grid connected)
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

