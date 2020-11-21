#!/bin/dash

# Use rofi if it's installed
if [ "$(which rofi 2>/dev/null)" ]; then
    LAUNCHER="rofi -dmenu $@"
else
    LAUNCHER="dmenu -l 30"
fi

# Cache file
CACHE="$HOME/.cache/umsd.cache"
# Save directory contents to cache
find "/run/media/$USER/"* -maxdepth "0" > "$CACHE"

# If the cache file contains at least one line
if [ "$(wc -l < "$CACHE" )" -gt 0 ]; then
    # Show a list of mounted drives
    $LAUNCHER < "$CACHE" | xargs umount
else
    # Otherwise, show a notification.
    notify-send -i drive-removable-media "No devices to unmount"
fi

