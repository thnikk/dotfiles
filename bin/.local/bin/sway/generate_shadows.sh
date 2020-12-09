#!/bin/bash

SIZE=$1
COLOR=$2

FD=$(( (SIZE*2) + 1 ))

magick -size ${FD}x${FD} radial-gradient:"$COLOR"77-none ~/.config/sway/unfocused.png
magick -size ${FD}x${FD} radial-gradient:"$COLOR"aa-none ~/.config/sway/focused.png

swaymsg reload
