#!/usr/bin/env sh
# Simple script for switching secondary display between VM and host automatically (based on whether the VM is running or not.)

if sudo virsh list --name | grep -q .; then
    echo "Changing secondary display to VM"
    sudo ddcutil setvcp 60 0x11 --sn C8LMTF091196
    swaymsg output DP-3 disable
else
    echo "Changing secondary display to host"
    sudo ddcutil setvcp 60 0x0f --sn C8LMTF091196
    swaymsg output DP-3 enable
fi
