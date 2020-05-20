#!/bin/bash

# This simple script returns the available fan speed and temperature for a named hwmon device. Some screwy stuff can happen with reassigned hwmon numbers, so this prevents any trouble between reboots caused by a kernel upgrade or hardware change.

# Return info for cpu if not defined
DEVICE="${1:-cpu}"

hwCheck() {
    # Check through all hwmon devices and look for names matching arguments
    for d in /sys/class/hwmon/hwmon*; do
        name=$(cat $d/name) >/dev/null
        # If requesting temp...
        if [[ $name == $1 ]]; then
            # Echo temp
            [ -f $d/temp1_input ] && echo -ne "$(( $(cat $d/temp1_input)/1000 ))C"
            # Add space if fan speed exists
            [ -f $d/temp1_input ] && [ -f $d/fan1_max ] && echo -ne " "
            # Echo fan speed percentage
            [ -f $d/fan1_max ] && echo -ne "$(( $(( $(cat $d/fan1_input)*100 ))/$(cat $d/fan1_max) ))%"
        fi
    done 2>/dev/null
}

# If your device isn't listed, add another hwCheck line with the name of your device.
case $DEVICE in
    cpu)
        hwCheck k10temp
        hwCheck coretemp
        echo ""
        ;;
    gpu)
        hwCheck amdgpu
        echo ""
        ;;
esac
