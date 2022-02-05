This builds various configurations of [OpenSimulator] for running same
in a [Docker] container. The Docker image that is built can include
several different runtime configurations or the OpenSimulator configuration
can be completely replaced at runtime.

## OpenSimulator Image

This builds the latest 'master' version of [OpenSimulator] into a Docker image.
The resulting Docker image has scripts
to run, log, and keep running the [OpenSimulator] instance. The image starts at
`/usr/opensim/bootOpenSim.sh` which checks for initial setup conditions and
then runs `/usr/opensim/run.opensim.sh` which starts [OpenSimulator] using `screen`.

## OpenSimulator Configuration

The [OpenSimulator] setup has a specialized configuration setup. This configuration
setup has:

- the default `OpenSimDefault.ini` and OpenSim.ini in place
- all of the usual config-include files nulled out (empty)
- a `bin/config/os-config` file that defines the environment variable 'CONFIG_NAME' which selects the runtime configuration
- the default 'CONFIG_NAME' is 'standalone'
- a set of scripts in 'bin/config' that does the simulation/region configuration

`/usr/opensim/bootOpenSim.sh` calls `bin/config/setup.sh` to
configure this particular [OpenSimulator] instance. `setup.sh` is called everytime
the Docker image is started. `setup.sh` uses `os-config` to define the environment
variable `CONFIG_NAME` and then uses the information in the same named sub-directory
to setup the configuration files for [OpenSimulator].

`bin/config/config-$CONFIG_NAME/Includes.ini` is copied into `bin/config`. This will be read
by [OpenSimulator] on startup and replaces all of the usual configuration includes.
There will usually be a `bin/config/$CONFIG_NAME/config-includes` that models the
usual [OpenSimulator] configuration directory.

This configuration design means that the complete [OpenSimulator] setup and
runtime configuration can be replaced by replacing the directory
`/usr/opensim/opensim/bin/config`. This allows mounting a configuration directory
for the Docker container to completely replace the setup and configuration.

Note that there are secrets needed to configure and run [OpenSimulator].
If you wish the passwords to be protected, their definition file can be
encrypted with `ccrypt`.
Read the comments in `config/os-secrets` for how to encrypt secrets.
The container is initially run with the 'CONFIGKEY' environment variable
which is the key for decrypting the secrets file.

## Building and Running

See the [main page README](../README.md) for instructions for building and running.

[OpenSimulator]: https://opensimulator.org
[Docker]: https://www.docker.com

