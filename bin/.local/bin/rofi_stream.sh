#!/usr/bin/env sh

if [ -z "$@" ]; then
    ls ~/.cache/stream_notify/live
else
    coproc ( mpv "$(grep "$@" $HOME/.config/stream_notify/config | awk '{print $2}')" & >/dev/null 2>&1 )
    exit;
fi
