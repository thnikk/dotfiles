#!/bin/bash
SELECTION=$(ls ~/.cache/stream_notify/live | rofi -dmenu)

URL="$(grep "$SELECTION" "$HOME/.config/stream_notify/config" | awk '{print $2}')"

mpv "$URL"
