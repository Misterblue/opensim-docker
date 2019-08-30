# Dockerfile for building a region server for OpenSimulator.
#
# This

FROM ubuntu

LABEL Version="0.9"
LABEL Description="Docker container for OpenSimulator region"

# install tools and Mono environment
# Kludge for TZ taken from https://github.com/QuantumObject/docker-opensimulator/blob/master/Dockerfile
ENV TZ America/Los_Angeles

RUN echo $TZ > /etc/timezone \
    && apt-get update \
    && apt-get install -y \
        tzdata \
        git \
        mono-complete \
        mono-reference-assemblies-4.0 \
    && rm /etc/localtime \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get clean \
    && rm -rf /tmp/* var/tmp/* \
    && rm -rf /var/lib/apt/lists/*

# The simulator is run under the user name 'opensim'
# (from https://stackoverflow.com/questions/36490627/how-to-create-and-run-docker-container-with-new-user-other-than-root)
# RUN export ACCT=opensim UID=1000 GID=1000 \
#     && mkdir -p /home/$ACCT \
#     && echo "$ACCT:x:${UID}:${GID}:Abc,,,:/home/$ACCT:/bin/bash" >> /etc/passwd \
#     && echo "$ACCT:x:${GID}:" >> /etc/group \
#     && echo "$ACCT ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$ACCT \
#     && chmod 0440 /etc/sudoers.d/$ACCT \
#     && chown ${UID}:${GID} -R /home/$ACCT

# (From https://stackoverflow.com/questions/27701930/add-user-to-docker-container)
RUN adduser --disabled-password --gecos 'OpenSimulator user' opensim \
    && echo "opensim:${OPENSIM_PASSWORD}" | chpasswd

WORKDIR /home/opensim
USER opensim:opensim

COPY NOOPENSIM /home/opensim
COPY checkOpenSim.sh /home/opensim
COPY captureCrash.sh /home/opensim
COPY checkOldLogFiles.sh /home/opensim
COPY run.opensim.sh /home/opensim
COPY firstTimeSetup.sh /home/opensim
COPY crontab /home/opensim

# Fetch and build the latest version of the sources
RUN git clone git://opensimulator.org/git/opensim /home/opensim/opensim \
    && ./runprebuild.sh \
    && xbuild

CMD /home/opensim/checkOpenSim.sh

# The simulator defaults to port 9000
# All ports are usually over-ridden by the 'docker run' command parameters.
EXPOSE 9000/tcp
EXPOSE 9000/udp

# The configuration of the region can be supplied via the 'config' subdirectory
VOLUME /home/opensim/opensim/bin/config

# HOW TO FIX?
# The OpenSim.ini file doesn't exist (it's OpenSim.ini.example). Is that a problem?
# When starting new regions, it will as for the estate info from the console.
# What about the configuration of MySQL?
# What about the configuration of asset cache?
