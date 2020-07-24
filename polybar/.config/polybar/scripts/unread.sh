#!/bin/bash

DIM="#747C84"
RED="#BF616A"
ICON=""

unread="$(find "${XDG_DATA_HOME:-$HOME/.local/share}"/mail/*/[Ii][Nn][Bb][Oo][Xx]/new/* -type f 2>/dev/null | wc -l )"

if [ "$unread" -gt 0 ]; then
    COLOR="$RED"
    SCOLOR='\e[31m'
else
    COLOR="$DIM"
    SCOLOR='\e[90m'
fi

# Shell colors
# \e[31m = red
# \e[39m = white
# \e[90m = dim

if [ "$1" = "-p" ]; then
    OUTPUT+="%{F$COLOR}$ICON%{F-}"
    pidof mbsync >/dev/null 2>&1 && OUTPUT+="%{T3} %{T-}~"
    [ "$unread" -gt 0 ] && OUTPUT+="%{T3} %{T-}$unread"
else
    OUTPUT+="$SCOLOR$ICON\e[39m"
    pidof mbsync >/dev/null 2>&1 && OUTPUT+="~"
    [ "$unread" -gt 0 ] && OUTPUT+="$unread"
fi

echo -e "$OUTPUT"
