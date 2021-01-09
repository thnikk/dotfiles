#!/bin/bash

DEVICE="Synaptics TM3075-002"

STATUS="$(xinput --list-props "$DEVICE" | grep "Device Enabled" | awk '{print $4}')"

case $STATUS in
    0) notify-send "Enabled trackpad."
        xinput enable "$DEVICE" ;;
    1) notify-send "Disabled trackpad."
        xinput disable "$DEVICE" ;;
esac

