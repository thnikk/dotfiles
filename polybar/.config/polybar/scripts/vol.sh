#!/bin/dash

# Simple alternative

VOL="$(pamixer --get-volume)"
MUTE="$(pamixer --get-mute)"

if pamixer --get-mute; then
    echo -n "%{F#747C84}MU%{F-}"
else
    [ "$VOL" -lt 10 ] && echo -n " "
    if [ "$VOL" -lt 100 ]; then
        echo -n "$VOL"
    else
        echo -n "99"
    fi
fi
