#!/bin/sh
if [ -f "/home/steam/valheim/start_server.sh" ]; then
    echo "start_server.sh exists, exiting."
    exit 0
fi
if [ "$PUBLIC_TEST" = true ] ; then
    steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir /home/steam/valheim +login anonymous +app_update 896660 -beta public-test -betapassword "yesimadebackups" validate +quit
else
    steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir /home/steam/valheim +login anonymous +app_update 896660 validate +quit
fi