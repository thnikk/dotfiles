#!/bin/bash
# List all libvirt VMs
# Using the -p flag will add polybar-specific features like highlighting active VMs and click actions for start, shutdown, and destroy.
# Using bash for process substitution and string appending, which is simpler and faster than using their POSIX equivalents.

OUTPUT=""
for line in /etc/libvirt/qemu/*.xml; do
    name="$(basename "$line" | cut -f 1 -d '.')"
    running=0
    sudo virsh list --name | grep -q "$name" && running=1
    [ $running = 0 ] && [ "$1" = "-p" ] && OUTPUT+="%{F#747C84}"
    [ "$1" = "-p" ] && OUTPUT+="%{A2:sudo virsh destroy $name:}%{A3:sudo virsh shutdown $name:}%{A1:sudo virsh start $name:}"
    OUTPUT+="$name"
    [ "$1" = "-p" ] && OUTPUT+="%{A}%{A}%{A}"
    [ $running = 0 ] && [ "$1" = "-p" ] && OUTPUT+="%{F-}"
    OUTPUT+=" "
done < <(sudo virsh list --name --all)

printf "%s" "${OUTPUT%?}"
