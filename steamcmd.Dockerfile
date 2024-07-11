# hadolint global ignore=DL3008
FROM ubuntu:24.04

# Insert Steam prompt answers
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
    && echo steam steam/license note '' | debconf-set-selections

# install steamcmd
RUN apt-get -y update \
    && apt-get install -y --no-install-recommends software-properties-common \
    && add-apt-repository multiverse \
    && dpkg --add-architecture i386 \
    && apt-get -y update \
    && apt-get install -y --no-install-recommends steamcmd \
    && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create symlink for executable
RUN ln -s /usr/games/steamcmd /usr/bin/steamcmd

# create steam user (non-root)
ENV USERNAME=steam
ENV GROUPNAME=${USERNAME}
ENV USER_UID=1001
ENV USER_GID=${USER_UID}
RUN groupadd --gid ${USER_GID} ${GROUPNAME} \
    && useradd --uid ${USER_UID} --system --gid ${USER_GID} ${USERNAME}
USER steam
WORKDIR /home/steam
ENV HOME=/home/steam

RUN steamcmd +quit

RUN mkdir -p /home/${USERNAME}/valheim
COPY --chown=${USER_UID}:${USER_GID} InstallUpdate.bash ./

ENTRYPOINT ["bash", "./InstallUpdate.bash"]