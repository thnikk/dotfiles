#!/bin/bash

ICON=""

unread="$(find "${XDG_DATA_HOME:-$HOME/.local/share}"/mail/*/[Ii][Nn][Bb][Oo][Xx]/new/* -type f 2>/dev/null | wc -l )"

if [ "$unread" -gt 0 ]; then
    COLOR="#BF616A"
else
    COLOR="#747C84"
fi

OUTPUT+="%{F$COLOR}$ICON%{F-}"
if pidof mbsync >/dev/null 2>&1; then
    OUTPUT+="~"
else
    OUTPUT+=" "
fi
[ "$unread" -gt 0 ] && OUTPUT+="$unread"

#echo -e "$OUTPUT"
echo -e "$unread"
