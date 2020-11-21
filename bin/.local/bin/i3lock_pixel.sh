#!/bin/bash

# This simple script takes a screenshot, pielates it, and sets it as the i3lock background.

# Use jpg for SPEED
IMAGE="/tmp/lock.jpg"

# Generate screenshot of currently focused monitor
maim $IMAGE

# Pixelate image
convert $IMAGE -resize 4% -scale 2500% "$IMAGE"

# Apply image as lockscreen
i3lock -i "$IMAGE" \
    --bar-indicator \
    --bar-width=1920 \
    --bar-max-height=10 \
    --color=000000FF \
    --insidecolor=00000000 \
    --ringcolor=00000000 \
    --linecolor=00000000 \
    --separatorcolor=00000000 \
    #--radius 35 \
    #--ring-width 8 \
