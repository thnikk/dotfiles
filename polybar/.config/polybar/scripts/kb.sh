#!/usr/bin/dash
# Get current input method
ENGINE=$(ibus engine | awk -F ":" '{print $NF}')

# Languages
# Escape colons
EN="xkb\:us\:\:eng"
JP="anthy"

# Display language and language to switch to on click
case $ENGINE in
    eng) SHORT="EN" CLICK="$JP";;
    anthy) SHORT="JP" CLICK="$EN";;
esac

# Echo output
echo "%{A1:ibus engine $CLICK | xargs notify-send:}$SHORT%{A}"
