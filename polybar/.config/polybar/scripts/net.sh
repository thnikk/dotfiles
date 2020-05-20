#!/bin/bash
j=0
# Check all networking devices
for i in $( ls /sys/class/net ); do
    if [[ $i != "lo" ]] && [[ -e /sys/class/net/$i/carrier ]] ;then
        CARRIER=$(cat /sys/class/net/$i/carrier 2>/dev/null)
        # If device is connected...
        if [[ $CARRIER == "1" ]];then
            ((j=j+1))
            if (( j > 1)); then echo -n " "; fi
            # Look for line with subnet mask to find ip
            OUTPUT=$(echo -n $(ip addr show $i | grep "/24" | awk '{print $2}' ))
            # Strip the /24 off the end
            echo "${OUTPUT%/24}"
            if [[ $i == "w"* ]];then
                    # wlp3s0 should be more universal
                echo -n "/$(iw wlp3s0 info | grep -Po '(?<=ssid).*' | tr -d ' ')"
            fi
        fi
    fi
done

if [ $j -eq "0" ];then
    echo "Disconnected"
fi

