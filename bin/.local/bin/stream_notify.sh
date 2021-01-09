#!/bin/bash
# Check if streamers are live
# This script is relatively slow due to how youtube-dl checks for streams.

# Required to display notifications if run as a cronjob:
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus
export DISPLAY=:0.0
# Required for playing sound
export XDG_RUNTIME_DIR="/run/user/1000"

CACHEDIR="$HOME/.cache/stream_notify"
CACHE="$CACHEDIR/cache"
LIVE="$CACHEDIR/live"
CONFIGDIR="$HOME/.config/stream_notify"
CONFIG="$CONFIGDIR/config"
SOUND="$HOME/.config/notifications/alert.ogg"


# Make necessary files and directories
[ -d "$CACHEDIR" ] || mkdir -p "$CACHEDIR"
[ -d "$LIVE" ] || mkdir -p "$LIVE"
[ -d "$CONFIGDIR" ] || mkdir -p "$CONFIGDIR"
[ -f "$CONFIG" ] || { echo '#[name] [stream url]'; echo "northernlion https://www.twitch.tv/northernlion"; } > "$CONFIG"

# Notify when streamer is live
notify() {
    notify-send "$1 is now live!"
    [ -f "$SOUND" ] && paplay --volume=40000 "$SOUND"
}

rm_file() {
    [ -f "$LIVE/$1" ] && rm -f "$LIVE/$1"
}


while IFS= read -r line; do
    NAME="$(echo "$line" | awk '{print $1}')"
    URL="$(echo "$line" | awk '{print $2}')"
    if mpv --load-scripts=no --no-audio --no-video "$URL" | grep -q 'No.*video.*or.*audio.*streams.*selected'; then
        echo "$NAME is currently live."
        if [ ! -f "$LIVE/$NAME" ]; then
            echo "$NAME just went live!"
            touch "$LIVE/$NAME"
            notify "$NAME"
        fi
    else
        rm_file "$NAME"
    fi
done < "$CONFIG"

