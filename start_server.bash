#!/bin/bash
export templdpath=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
export SteamAppId=892970

echo "Starting server PRESS CTRL-C to exit"

# Tip: Make a local copy of this script to avoid it being overwritten by steam.
# NOTE: Minimum password length is 5 characters & Password cant be in the server name.
# NOTE: You need to make sure the ports 2456-2458 is being forwarded to your server through your local router & firewall.

# See "List of Console Commands" at https://www.valheimgame.com/support/a-guide-to-dedicated-servers/
./valheim_server.x86_64 -name "${SERVER_NAME}" -port 2456 -world "${WORLD_NAME}" -password "${SERVER_PASS}"

export LD_LIBRARY_PATH=$templdpath


