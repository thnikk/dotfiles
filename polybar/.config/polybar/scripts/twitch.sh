#!/bin/bash

count=0

# Print all live streams on the same line
for x in "$HOME/.cache/stream_notify/live"/*; do
    # If this loop is run through more than once, add a space between streams.
    [ "$count" -gt 0 ] && OUTPUT+=" "
    if ! grep -q "\*" <<< "$x"; then
        fullname="$(basename "$x")"
        case "$fullname" in
            # Create shorthand name for streamers
            dangheesling) name="DG" ;;
            darksydephil) name="DSP" ;;
            northernlion) name="NL" ;;
            *) name="$1" ;;
        esac
        OUTPUT+="%{A1:xdg-open https\:\/\/twitch.tv\/$fullname:}$name%{A}"
    else
        [ "$count" = 0 ] && exit 1
    fi
    count=$(( count + 1 ))
done

printf "%s" "$OUTPUT"
