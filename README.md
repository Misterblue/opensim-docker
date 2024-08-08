# OpenSimulator on Docker

Various configuration files and setups for running [OpenSimulator] in
[Docker] containers. The model builds a Docker image of [OpenSimulator]
and then that image can be run with different configurations (standalone,
grid, ...).

There was a presentation on this project at the
[OpenSimulator Community Conference 2019](https://conference.opensimulator.org/2019/)
that is available at
[OSCC19 Dockerizing OpenSimulator](https://www.youtube.com/watch?v=-EnTepHqLA4) .

This is organized into building *images* and having *config*s for those images.

The model is for one to build a Docker image with one of the [OpenSimulator]
images in it and, at runtime, choose one of the configurations to
run it with. The [OpenSimulator] "image" is a built version of the source
code and the "config" is the collection of INI files that are used to run it.

The images have no configuration in them. In the image, most of the .ini files
have been nulled out. Configuration is completely specified by mounting
a configuration directory when the [Docker] image is run.

Three images are currently present:
`image-ncg` which is a built of the [NCG] 'develop' branch,
`image-opensim` which is a built of the straight [OpenSimulator] 'master' branch,
and `image-opensim-herbal3d` which is [OpenSimulator] built with
the [Herbal3d] addon modules.
(Since I'm the Herbal3d main developer, this is how I test it.)

The Docker images are run using `docker-compose` to set up ports
and environment. Additionally, if a database server is needed,
that is also started and linked to the [OpenSimulator] instance.
[MariaDB] is used for the external SQL server.

As an example, to create an image of standard [OpenSimulator]
and sets it up to run with a separate SQL database server to
store data:

```
# Get these configuration files
cd
git clone https://github.com/Misterblue/opensim-docker.git

# Use the regular OpenSimulator with a standalone setup for this example:
cd opensim-docker/image-opensim

# Edit the file `env` with parameters for the container to be built. In
#    particular, specify which configuration to use (`OS_CONFIG`)

cd config-$OS_CONFIG

# Edit "os-secrets" with login and database accounts and passwords
# If you want to keep things hidden, one can follow the instructions in os-secrets
#     and encrypt os-secrets.

# Do any additional OpenSimulator configuration
# Edit 'config-$OS_CONFIG/Include.ini for BaseHostname and server ports
# Edit 'config-$OS_CONFIG/config-include/*.ini for grid connections
# Edit 'config-$OS_CONFIG/Regions/Regions.ini for region location
# Edit 'config-$OS_CONFIG/config-include/Final.ini for DatabaseService and other settings

# Build OpenSimulator image
cd
cd opensim-docker/image-opensim
./build-opensim.sh

# Run the composed container set
./run-opensim.sh
```

Notice that nearly all of the configuration of the running OpenSimulator
is done in the `Final.ini` file. All the configurations from the OpenSimulator
sources and the defaults that are in the source repository and these values
are overlayed by the last INI file which, in this case, is `Final.ini`.

By default, the [Docker] image that is run is the local built image.
Optionally, one can use an image in a remote repository.
Most people will build their own local image, though,
as you will probably want to be using the latest [OpenSimulator]
sources and thus require a fresh build.

## Image Operation

The `Dockerfile`s setup the image with a few scripts to configure and start
[OpenSimulator], periodically check for crashes, copy crash'ed log files,
and restart the simulator if it's not running.

Which configuration is used is specified by environment variables which 
must be set. The environment variables are:

-- *OS_CONFIG*: the configuration to use (like "standalone" or "standalone-sql")
-- *OPENSIM_CONFIGKEY*: (optional) the password for extracting secrets in .crypt files

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
- `OpenSim.ini.example` is not used and is ignored
- the files in `config-include` are emptied so they don't do anything when included by any script
- configuration uses the feature that [OpenSimulator] reads all the INI files from
  a specified directory (default is ./bin/config). This directory is mounted
  to a directory external to the [Docker] container and based on the `OS_CONFIG`.

In the mounted configuration directory, the file `setup.sh` is run before [OpenSimulator]
is started to do any setup.

`docker-compose` mounts the container's `bin/config` directory as the `config/`
directory so all configuration is loaded from the external directory.
This means that a complete configuration must be created outside the Docker
container.

## Running the Docker Image

Once the Docker image is built, it can be run with a command like:

```
CONFIG_NAME=standalone CONFIGKEY=secretPassword ./run-opensim.sh
```

Once started, a `docker ps` will show something like:

<pre>
$ docker ps
CONTAINER ID   IMAGE            COMMAND                  CREATED         STATUS         PORTS                                                                                                                                                                        NAMES
36f4c81d8d22   opensim-ncg      "/home/opensim/bootO…"   6 seconds ago   Up 5 seconds   0.0.0.0:9000->9000/tcp, 0.0.0.0:9000->9000/udp, :::9000->9000/tcp, :::9000->9000/udp, 0.0.0.0:9010->9010/tcp, 0.0.0.0:9010->9010/udp, :::9010->9010/tcp, :::9010->9010/udp   opensim-standalone-opensim-1
5f550c90eebd   mariadb:latest   "docker-entrypoint.s…"   6 seconds ago   Up 5 seconds   3306/tcp                                                                                                                                                                     opensim-standalone-dbservice-1
</pre>

Which shows the two containers started for the simulator and the database.

The number under "CONTAINER ID" is and ID one uses to address the container. The command

The command `docker logs ID` will list the startup output when the container was started. An example:

```
$ docker logs 36f4c81d8d22
Starting OpenSimulator version 0.9.3.0
   with opensim-docker version 4.0.1-20240806-62fda19
   using configuration set ""
opensim-docker: setup.sh: OPENSIMCONFIG="/home/opensim/opensim/bin/config"
opensim-docker: setEnvironment.sh: trying plain text secrets
opensim-docker: setEnvironment.sh: plain text secrets from "/home/opensim/opensim/bin/config/os-secrets"
opensim-docker: setup.sh: first time
opensim-docker: initializeDb.sh:
ERROR 2002 (HY000): Can't connect to server on 'dbservice' (115)
opensim-docker: initializeDb.sh: Waiting on database to be ready
opensim-docker: initializeDb.sh: Database is ready
opensim-docker: initialzeDb.sh: opensim database has already been created
$
```

The configuration scripts output messages that will help finding any problems.

To get a console on the OpenSimulator container, the command is

```
docker exec -it ID /bin/bash
```

(that is, execute an interactive command on the container). This will open a Bash shell on the container.

OpenSimulator is started with Screen. Once running the Bash shell on the container, the command:

```
screen -r OpenSimScreen
```

will connect you to the OpenSimulator console. *TO EXIT SCREEN* the command is `cntl-A` followed by `cntl-D`.

[OpenSimulator]: https://opensimulator.org
[Docker]: https://www.docker.com
[Herbal3d]: https://www.herbal3d.org
[MariaDB]: https://mariadb.org/
[NCG]: https://github.com/OpenSim-NGC/OpenSim-Sasquatch

