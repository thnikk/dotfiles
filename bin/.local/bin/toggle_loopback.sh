#!/bin/dash

if pactl list modules short | grep -q loopback ; then
    pactl unload-module module-loopback
else
    pactl load-module module-loopback rate=48000 latency_msec=1 source=1
fi
