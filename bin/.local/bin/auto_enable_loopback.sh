#!/bin/bash

LOOP_EN=0

while true; do
    if [ "$(pacmd list-sources | grep -c RUNNING)" -gt 2 ]; then
        if [ $LOOP_EN -eq 0 ]; then
            LOOP_EN=1
            echo "Enabling loopback"
            pacat -r --latency-msec=1 -d 1 | pacat -p --latency-msec=1 -d 0 &
        fi
    else
        if [ $LOOP_EN -eq 1 ]; then
            echo "Disabling loopback"
            pkill pacat
            LOOP_EN=0
        fi
    fi
    sleep 1
done
