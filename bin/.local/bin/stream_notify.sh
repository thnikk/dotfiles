#!/usr/bin/env sh

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
[ -f "$CONFIG" ] || echo "northernlion" > "$CONFIG"

# Notify when streamer is live
notify() {
    notify-send "$1 is now live!"
    [ -f "$SOUND" ] && paplay --volume=40000 "$SOUND"
}

rm_file() {
    [ -f "$LIVE/$1" ] && rm -f "$LIVE/$1"
}


check_status() {
    streamlink "twitch.tv/$1" > "$CACHE"

    # If there's an avalable stream
    if grep -q 'Available' "$CACHE"; then
        # And they're not hosting
        if ! grep -q 'hosting' "$CACHE"; then
            # Create a file and display a notification
            echo "$1 is live."
            if [ ! -f "$LIVE/$1" ]; then
                touch "$LIVE/$1"
                notify "$1"
            fi
        # Otherwise, remove the file
        else
            rm_file "$1"
        fi
    else
        rm_file "$1"
    fi
}

while IFS= read -r line; do
    check_status "$line"
done < "$CONFIG"

