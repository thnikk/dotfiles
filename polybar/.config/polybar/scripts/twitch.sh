#!/bin/bash

# Pass through first argument as space
SPACE=${1:-" "}

# Create output variable that we append text to later
OUTPUT=""
# Define location of config
CONFIG="$HOME/.config/stream_notify/config"

# If the config file doesn't exist, prompt the user to make it.
[ ! -f "$CONFIG" ] && echo "Please create a config file at $CONFIG with one streamer name per line." && exit 1

# Read all names from config file
while read -r line; do
    # Create shorthand name for streamers, otherwise just use the full name
    case "$line" in
        dangheesling) name="D" ;;
        darksydephil) name="P" ;;
        northernlion) name="N" ;;
        *) name="$1" ;;
    esac
    # Append click action to open stream
    OUTPUT+="%{A1:xdg-open https\:\/\/twitch.tv\/$line:}"
    # Append name (dim if not live)
    if [ "$(ls ~/.cache/stream_notify/live | grep -c "$line")" -gt 0 ]; then
        OUTPUT+="$name"
    else
        OUTPUT+="%{F#747C84}$name%{F-}"
    fi
    # Append closing tag for click action and trailing space
    OUTPUT+="%{A-}$SPACE"
done < ~/.config/stream_notify/config

# Print and remove final trailing space
printf "%s" "${OUTPUT/%$SPACE/}"
