#!/bin/bash

mapfile -t WH < <(swaymsg -t get_tree | jq -r '.. | (.nodes? // empty)[] | select(.focused==true) | .window_rect | .width,.height ' )

echo "width: ${WH[0]}, height: ${WH[1]}"

if [ "${WH[0]}" -lt "${WH[1]}" ]; then
    echo "Splitting vertically"
    i3-msg split v
else
    echo "Splitting horizontally"
    i3-msg split h
fi

