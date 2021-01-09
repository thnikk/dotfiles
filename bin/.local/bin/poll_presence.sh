#!/bin/bash

# This script will update discord's rich presence status with what's being played in mpv.
# If given the -c flag, it checks to see if the video name is included in ~/.cache/lsa.cache before updating the status. This is generated outside of the script.

# Dependencies:
# mpv-mpris
# pypresence
# rpc_connect.py

# If the script is closed, kill rpc_connect.py
trap "pkill -f rpc_connect" EXIT

# Start seconds at 15 so it can update right away
SECONDS=15

# Main loop
while true; do
    # Get title
    TITLE="$(playerctl -p mpv metadata 2>/dev/null | grep title | awk -F'  ' '{print $NF}' | sed 's/_/ /g;s/\[[^][]*\]//g;s/([^()]*)//g;s/.mkv//g;s/^ *//g;s/ *$//g')"
    # Get player status
    STATUS="$(playerctl -p mpv status 2>/dev/null)"

    # Update if name or title has changed
    if [ "$OLD_TITLE" != "$TITLE" ] || [ "$OLD_STATUS" != "$STATUS" ] ; then
        # Only update RPC every 15 seconds
        if [ $SECONDS -gt 15 ]; then
            # Echo title and status
            echo "$TITLE $STATUS"
            # Update discord RPC if the player is active and the video is in cache
            if [ ! -z "$TITLE" ] && [ "$STATUS" = "Playing" ]; then
                if [ "$1" = "-c" ]; then
                    grep -q "$TITLE" ~/.cache/lsa.cache && ~/.local/bin/rpc_connect.py "$TITLE" >/dev/null 2>&1 &
                else
                    ~/.local/bin/rpc_connect.py "$TITLE" >/dev/null 2>&1 &
                fi
            else
                # Otherwise, kill RPC
                pkill -f rpc_connect >/dev/null 2>&1
            fi

            # Update last checked values
            OLD_TITLE=$TITLE
            OLD_STATUS=$STATUS
            SECONDS=0
        fi
    fi

    # Loop speed
    sleep 1
done
