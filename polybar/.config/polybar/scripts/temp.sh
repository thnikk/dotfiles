#!/bin/bash

# Get temperature for a device
get_temp(){
    FILE=$(echo "$1" | awk '{print $NF}')
    TEMP="$(cat "$FILE")"
    echo "$(( TEMP/1000 ))"
}

OUTPUT=()

while IFS= read -r line; do
    case $line in
        # If junction temp of amd gpu
        *amdgpu*junction*)
            OUTPUT+=("G$(get_temp "$line")")
            ;;
        # If die temp of amd cpu
        *k10temp*Tdie*)
            OUTPUT+=("C$(get_temp "$line")")
            ;;
        # Intel CPU
        *coretemp*Package*)
            OUTPUT+=("C$(get_temp "$line")")
            ;;
        *) ;;
    esac
done <<< "$(for i in /sys/class/hwmon/hwmon*/temp*_input; do echo "$(<$(dirname $i)/name) $(cat ${i%_*}_label 2>/dev/null || echo $(basename ${i%_*})) $(readlink -f $i)"; done)"

# echo all contents of list (auto insterts spaces between options
echo "${OUTPUT[@]}"
