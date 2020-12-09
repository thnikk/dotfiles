#!/usr/bin/env sh

STATUS="$(swaymsg -t get_inputs -p | grep -i 'input.*synaptics' -A 5 | grep 'Events' | awk -F':' '{print $2}')"

case $STATUS in
    *"enabled"*) swaymsg input "$(swaymsg -t get_inputs -p | grep -i 'input.*synaptics' -A 5 | grep Identifier | awk '{print $2}')" events disabled ;;
    *"disabled"*) swaymsg input "$(swaymsg -t get_inputs -p | grep -i 'input.*synaptics' -A 5 | grep Identifier | awk '{print $2}')" events enabled ;;
esac
