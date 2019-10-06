This builds various configurations of [OpenSimulator] modified with the
[Herbal3d] region modules and running in [Docker] containers.
The `docker-compose` setup runs three containers:

- [OpenSimulator] image containing the [Herbal3d] modules,
- [MariaDB] image for the simulator database,
- [nginx] server serving the [BasilJS] web pages for viewing/testing [Herbal3d]

## OpenSimulator Image

This builds the latest 'master' version of [OpenSimulator] along with all the Herbal3D
addon-modules into a Docker container. The resulting Docker image has scripts
to run, log, and keep running the [OpenSimulator] instance. The image starts at
`/usr/opensim/bootOpenSim.sh` which checks for initial setup conditions and
then runs `/usr/opensim/run.opensim.sh` which starts [OpenSimulator] using `screen`.

## OpenSimulator Configuration

The [OpenSimulator] setup has a specialized configuration setup. This configuration
setup has:

- the default OpenSimDefault.ini and OpenSim.ini in place
- all of the usual config-include files nulled out (empty)
- a 'bin/config/os-config' file that defines the environment variable 'CONFIG_NAME'
- the default 'CONFIG_NAME' of 'standalone'
- a set of scripts in 'bin/config' that initialized and configure

`/usr/opensim/bootOpenSim.sh` calls `/usr/opensim/opensim/bin/config/setup.sh` to
configure this particular [OpenSimulator] instance. `setup.sh` is called everytime
the Docker image is started. `setup.sh` uses `os-config` to define the environment
variable `CONFIG_NAME` and then uses the information in the same named sub-directory
to setup the configuration files for [OpenSimulator].

`bin/config/$CONFIG_NAME/Includes.ini` is copied into `bin/config`. This will be read
by [OpenSimulator] on startup and replaces all of the usual configuration includes.
There will usually be a `bin/config/$CONFIG_NAME/config-includes` that models the
usual [OpenSimulator] configuration directory.

This configuration design means that the complete [OpenSimulator] setup and
runtime configuration can be replaced by replacing the directory
`/usr/opensim/opensim/bin/config`. This allows mounting a configuration directory
for the Docker container to completely replace the setup and configuration.

Note that there are secrets needed to configure and run [OpenSimulator].
These are stored in a 'ccrypt' encrypted file. Read the comments in
'/usr/opensim/opensim/bin/config/os-secrets' for how to encrypt secrets.
The container is initially run with the 'CONFIGKEY' environment variable
which is the key for decrypting the secrets file.

## Building and Running

This is organized so there can be several different configurations
of [OpenSimulator] and [Herbal3d] in this source tree.
The configuration to use is selected by setting the `CONFIG_NAME`
environment variable.

Initially, there are two configuratios:

- standalone: a simple run of OpenSimulator image in a single docker container
- three: this creates a three docker container set that includes:
  * OpenSimulator simulator with the Herbal3d addon-modules;
  * an nginx web server serving BasilJS; and
  * a MariaDB server used by the OpenSimulator regions

These configurations include all the setup and configuration for the
OpenSimulator instance such as region names and locations.
To create a new configuration, copy the `three` file tree into
a new directory, edit that new set of configuration files, and
do the build and run with your new directory name as `CONFIG_NAME`.

The steps to build and run the containers:

```bash
# Get these configuration files
cd
git clone https://github.com/Herbal3d/opensim-docker.git
cd opensim-docker/opensim-herbal3d

export CONFIG_NAME=three

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

# Build OpenSimulator/Herbal3d image
cd
cd opensim-docker/opensim-herbal3d
./build-herbal3d.sh

# Build BasilJS image
cd
cd opensim-docker/opensim-herbal3d
./build-basiljs.sh

# Run the composed container set
CONFIG_NAME=three CONFIGKEY=secretPassword EXTERNAL_HOSTNAME=whateverTheHostnameIs ./run-herbal3d.sh

```

[OpenSimulator]: https://opensimulator.org
[Docker]: https://www.docker.com
[Herbal3d]: https://www.herbal3d.org
[BasilJS]: https://github.com/Herbal3d/basil
[nginx]: https://www.nginx.com/

