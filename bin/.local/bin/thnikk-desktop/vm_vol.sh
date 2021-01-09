#!/bin/bash

# Process args
while getopts ":v:c:" arg; do
  case $arg in
    v) VM=$OPTARG;;
    c) CHANGE=$OPTARG;;
    *) ;;
  esac
done

# Quit if no VM specified
[ -z "$VM" ] && exit 1

# First, check if VM is running
if ! sudo virsh list --name | sed '/^$/d' | grep -q "$VM"; then
    echo "VM not running"
    exit
else
    # Then check if service is active
    if ! systemctl --user is-active --quiet scream-pulse.service; then
        systemctl --user restart scream-pulse.service
    fi
fi

# If both checks are OK, allow volume to be adjusted
# Get all info
while IFS= read -r line; do
    case $line in
        "Sink Input"*) INPUT="$(echo "$line" | awk -F '#' '{print $2}')" ;;
        # This will only pull the volume level from one channel, so it's assuming L and R match.
        *"Volume"*) VOL="$(echo "$line" | awk -F '/' '{print $2}' | sed 's/\ //g;s/\%//g')" ;;
    esac
done <<< "$(pactl list sink-inputs | grep "Scream" -B 9999 | tac | grep -m1 "Sink Input" -B 9999)"

echo "Sink input: $INPUT"
echo "Volume: $VOL%"
echo "VM: $VM"

if [ -n "$CHANGE" ]; then
    echo "Change: $CHANGE"
    NEWVOL="$(echo "$VOL + $CHANGE" | bc)"
    if [ "$NEWVOL" -gt 100 ]; then
        NEWVOL=100
    elif [ "$NEWVOL" -lt 0 ]; then
        NEWVOL=0
    fi
    echo "New volume: $NEWVOL%"
    pactl set-sink-input-volume "$INPUT" "$NEWVOL%"
fi

if [ -z "$NEWVOL" ]; then
    notify-send.sh --replace-file ~/.cache/notify-id -i audio-speakers "VM Volume: $VOL%"
else
    notify-send.sh --replace-file ~/.cache/notify-id -i audio-speakers "VM Volume: $NEWVOL%"
fi
