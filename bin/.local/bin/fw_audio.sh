#!/bin/bash
# Requires gnu netcat for piping audio into pacat
# Also requires enabling audio over TCP in server's PA config

[ -z "$1" ] && echo "Usage: fw_audio.sh <ip/hostname>" && exit 1
nc "$1" 8000 -i 5 | pacat --rate 48000 --latency-msec=5
