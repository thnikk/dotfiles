#!/bin/bash

# Required to display notifications if run as a cronjob:
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus
export DISPLAY=:0.0
# Required for playing sound
export XDG_RUNTIME_DIR="/run/user/1000"
SOUND="$HOME/.config/notifications/nipah.ogg"

printers=("spro2" "spro" "simple" "play" "play2")
printerStatus=()
lastStatus=()

# Counter to disable notificaitons on first run
x=0

while true; do

    # Iterate through length of printer array
    for (( i=0; i<${#printers[@]}; i++ )); do
        # Get printer status
        printerStatus[$i]=$(mosquitto_sub -h 10.0.0.29 -t "${printers[$i]}/event/PrinterStateChanged" -C 1 | jq -r '.state_string')
        # If the status doesn't match what it was the last time through the loop:
        if [ "${lastStatus[$i]}" != "${printerStatus[$i]}" ]; then
            # Update status
            lastStatus[$i]=${printerStatus[$i]}
            # Only send notifications after startup check
            if [ $x != 0 ]; then
                # Play a sound if it exists
                [ -f "$SOUND" ] && paplay --volume=40000 "$SOUND"
                # Send notification
                notify-send "${printers[$i]}: ${printerStatus[$i]}"
            fi
        fi

        # Echo status for debugging
        #echo "${printers[$i]}: ${printerStatus[$i]}/${lastStatus[$i]}"

    done

    # Enable notifications after first loop
    x=1

    # Check every 10 seconds
    sleep 10

done
