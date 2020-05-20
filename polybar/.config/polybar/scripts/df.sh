#!/bin/bash
# Returns all storage devices on a single line, only showing their mount directory and percentage

P1=$( df -lh | while read -r line ; do
    var=$(
        # Filter only devices that show up under /dev
        grep /dev/ |
        # Hide shmem devices
        grep -v shm |
        # Hide boot partition
        grep -v boot |
        # Only pull dir name and percentage
        awk '{print $6":"$5}' |
        # Remove everything before the last /
        awk -F "/" '{print $(NF)}'
        )
        # If the dir starts with : (only for root)
        if [[ $var == :* ]]; then
            # Add back / for root
            echo -n "/"
        fi
        # and echo the rest
        echo -n $var
    done |
    # Filter the output through sed to replace "home" with ~
    sed 's/home/~/g' | sed 's/%//g'
)
P2=$(echo -n $(df -a | grep nfs | grep % | awk '{print $6":"$5}' | awk -F "/" '{print $(NF)}') | sed 's/server/S/g' | sed 's/%//g' )
# Always show local drives
echo -n $P1
# Hide nfs drives on laptop
if [ $(hostname) != "thnikk-laptop" ]; then
echo -n " $P2"
fi
