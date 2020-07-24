#!/bin/bash

# This simple script returns the available fan speed and temperature for a named hwmon device. Some screwy stuff can happen with reassigned hwmon numbers, so this prevents any trouble between reboots caused by a kernel upgrade or hardware change.

# Return info for cpu if not defined
DEVICES="k10temp coretemp amdgpu"
OUTPUT=""

LOAD=0
SEP="%{T3} %{T-}%{F#747C84}|%{F-}%{T3} %{T-}"

if [ $LOAD = 1 ]; then
    CPULOAD="$(awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else print ($2+$4-u1) * 100 / (t-t1) "%"; }' <(grep 'cpu ' /proc/stat) <(sleep 1;grep 'cpu ' /proc/stat) | awk -F'.' '{print $1}')"
    AMDGPULOAD="$(sudo radeontop -d - -l 1 | grep "gpu" | awk '{print $5}' | awk -F'.' '{print $1}')"
fi

hwCheck() {
    # Check through all hwmon devices and look for names matching arguments
    for d in /sys/class/hwmon/hwmon*; do
        name=$(cat "$d/name") >/dev/null
        # If we find a match,
        if [ "$name" = "$1" ]; then
            [ -z "$OUTPUT" ] || OUTPUT+="$SEP"
            if [ "$1" = "k10temp" ] || [ "$1" = "coretemp" ]; then
                OUTPUT+="%{F#747C84}%{F-}%{T3} %{T-}"
                [ -z "$CPULOAD" ] || OUTPUT+="L$CPULOAD% "
            fi
            if [ "$1" = "amdgpu" ]; then
                OUTPUT+="%{F#747C84}%{F-}%{T3} %{T-}"
                [ -z "$AMDGPULOAD" ] || OUTPUT+="L$AMDGPULOAD% "
            fi
            # Echo temp
            [ -f "$d/temp1_input" ] && OUTPUT+="T$(( $(cat "$d/temp1_input")/1000 ))C"
            # Add space if fan speed exists
            [ -f "$d/temp1_input" ] && [ -f "$d/fan1_max" ] && OUTPUT+="%{T3} %{T-}"
            # Echo fan speed percentage
            [ -f "$d/fan1_max" ] && OUTPUT+="F$(( $(( $(cat "$d/fan1_input")*100 ))/$(cat "$d/fan1_max") ))%"
        fi
    done 2>/dev/null # Ignore errors
}

for i in $DEVICES; do
    hwCheck "$i"
done

echo "$OUTPUT"

# If your device isn't listed, add another hwCheck line with the name of your device.
#case $DEVICE in
    #cpu)
        ## AMD
        #hwCheck k10temp
        ## Intel
        #hwCheck coretemp
        #echo ""
        #;;
    #gpu)
        ## AMD
        #hwCheck amdgpu
        #echo ""
        #;;
#esac
