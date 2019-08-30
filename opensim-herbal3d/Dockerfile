# OpenSim with Herbal3d region modules
# docker run --name=opensim -p 9000:9000 -p 9000:9000/udp -d opensim

FROM mono:5 as built
# FROM mono:4.6 as built

LABEL Version="0.1"
LABEL Description="Docker container running OpenSimulator with Herbal3d extensions"

ENV OPENSIMDIR=/home/opensim/opensim

RUN apt-get update \
    && apt-get install -y \
        coreutils procps git vim \
        screen \
        ccrypt \
        cron \
        mysql-client \
        sqlite \
    && rm -rf /var/lib/apt/lists/*

# Scripts that keep OpenSimulator running, make crash reports, clean up log files, etc
COPY scripts/* /home/opensim/
COPY vimrc /home/opensim/.vimrc

# Fetch the latest version of the OpenSimulator sources.
RUN cd /home/opensim \
    && git clone git://opensimulator.org/git/opensim \
    && cp $OPENSIMDIR/bin/OpenSim.ini.example $OPENSIMDIR/bin/OpenSim.ini

# Add the Herbal3d addon modules
RUN cd $OPENSIMDIR/addon-modules/ \
    && git clone https://github.com/Herbal3d/HerbalCommonEntitiesCS.git \
    && git clone https://github.com/Herbal3d/HerbalTransportCS.git \
    && git clone https://github.com/Herbal3d/Loden.git \
    && git clone https://github.com/Herbal3d/OSAuthModule.git \
    && git clone https://github.com/Herbal3d/RaguOS.git

# Copy the default INI files for Herbal3d services to where they will be read
RUN mkdir -p $OPENSIMDIR/bin/config \
    && cp $OPENSIMDIR/addon-modules/RaguOS/RaguOS.ini $OPENSIMDIR/bin/config \
    && cp $OPENSIMDIR/addon-modules/Loden/Loden.ini $OPENSIMDIR/bin/config

# OpenSim.ini does an include of "config-include/Standalone.ini".
#     so copy an empty version to nullfy the default configuration.
COPY config-include/ $OPENSIMDIR/bin/config-include/
# Copy over any extra configuration files we're including
COPY config/ $OPENSIMDIR/bin/config/

# Build OpenSimulator
RUN cd $OPENSIMDIR \
    && ./runprebuild.sh \
    && nuget restore OpenSim.sln \
    && cp packages/*/lib/net45/* bin \
    && msbuild

# ============================================================================
# 'slim' doesn't run OpenSimulator so it can't be used
# FROM mono:5-slim
FROM mono:5

ENV OPENSIMDIR=/home/opensim/opensim

RUN apt-get update \
    && apt-get install -y \
        coreutils procps git vim \
        procps \
        screen \
        ccrypt \
        cron \
        mysql-client \
        sqlite \
    && rm -rf /var/lib/apt/lists/*

# The simulator is run under the user name 'opensim'
# (From https://stackoverflow.com/questions/27701930/add-user-to-docker-container)
RUN adduser --disabled-password --gecos 'OpenSimulator user' opensim

COPY --from=built --chown=opensim:opensim /home/opensim/ /home/opensim

USER opensim:opensim
WORKDIR $OPENSIMDIR/bin
ENTRYPOINT [ "/home/opensim/bootOpenSim.sh" ]

# No ports are exposed by default since the simulator and regions can be anywhere.
# The simulator defaults to port 9000.
# EXPOSE 9000/tcp
# EXPOSE 9000/udp

# Directories that can be overridden with a mounted volume for configuration.
# The default configuration is for a simple standalone region.
# All the normal configuration has been nulled out (OpenSim.ini is the default
#    and all the included files in bin/config-include are empty).
#    A non-standalone configuration replaces bin/config with files that do
#    the configuration of the whole system (include 'architecture' ini file and
#    the necessary other INI files).
VOLUME $OPENSIMDIR/bin/config

