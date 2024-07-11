# hadolint global ignore=DL3008
FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    # resolve ssl issues
    ca-certificates \
    # # included Valheim Dedicated Server at docker/Dockerfile
    # curl libatomic1 libpulse-dev libpulse0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN update-ca-certificates

# create steam user (non-root)
ENV USERNAME=steam
ENV GROUPNAME=${USERNAME}
ENV USER_UID=1001
ENV USER_GID=${USER_UID}
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN groupadd --gid ${USER_GID} ${GROUPNAME} \
    && useradd --uid ${USER_UID} --system --gid ${USER_GID} ${USERNAME}
USER steam
WORKDIR /home/steam
ENV HOME=/home/steam

RUN mkdir -p /home/${USERNAME}/valheim
COPY --chown=${USER_UID}:${USER_GID} start_server.bash ./

WORKDIR /home/steam/valheim
EXPOSE 2456
ENTRYPOINT [ "/bin/bash", \
    "-c", \
    "cp /home/steam/start_server.bash . && bash ./start_server.bash" \
    ]