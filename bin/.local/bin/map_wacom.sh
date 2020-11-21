#!/bin/bash
# This simple script maps your wacom tablet to your primary display.

# Check for xsetwacom
[ -v "$(xsetwacom >/dev/null 2>/dev/null)" ] || echo "xsetwacom not installed." && exit 1

# Set variables
DEVICE=$(xsetwacom --list devices | grep -i stylus | rev | awk '{print $3}' | rev)
OUTPUT=$(xrandr | grep primary | awk '{print $1}')

# If no device
[ "$DEVICE" ] || DEVICE="MISSING"

# Echo variables
echo "Device is $DEVICE"
echo "Primary display is $OUTPUT"

# Map tablet
if [ "$(xsetwacom set "$DEVICE" MapToOutput "$OUTPUT" > /dev/null 2>/dev/null)" ]; then
    # Display notification
    notify-send "Wacom tablet mapped to primary display."
else
    echo "Cannot map tablet to display."
    echo "Make sure you have:"
    echo -e '\t'"Rebooted after installing the driver."
    echo -e '\t'"Set a primary display."
    echo -e '\t'"Plugged the tablet in."
    exit 1
fi
