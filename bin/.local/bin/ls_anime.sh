#!/usr/bin/dash

#DIR="$HOME/Videos/Anime"

# Pull cache file from server
# This requires a server-side script but is much faster.
CACHE="$HOME/.cache/lsa.cache"
scp 10.0.0.29:$CACHE $CACHE

# List all files + dates, sort, pull out videos, and remove date
#find -L "$DIR" -printf "%T+\t%p\n" | sort -r | grep "mkv" | awk -F '\t' '{print $NF}' > "$CACHE"

# Get the selection from rofi
SELECTION="$(cat $CACHE | awk -F'/' '{print $NF}' | sed 's/\[[^][]*\]//g;s/.mkv//g;s/^ *//g;s/ *$//g' | rofi -dmenu -i "$@")"
# If user closes rofi (presses escape,) exit the script
[ -z "$SELECTION" ] && exit 1
# Open the file
grep -F "$SELECTION" "$CACHE" | xargs -I {} xdg-open {}
