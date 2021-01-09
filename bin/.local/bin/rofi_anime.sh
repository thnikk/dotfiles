#!/bin/bash

CACHE="$HOME/.cache/lsa.cache"

if [ -z "$@" ]; then
    awk -F'/' '{print $NF}' < "$CACHE" | sed 's/\[[^][]*\]//g;s/.mkv//g;s/^ *//g;s/ *$//g'
else
    FILE=$(grep -F "$@" "$CACHE")
    coproc mpv "${FILE}"
    disown
    exit;
fi
