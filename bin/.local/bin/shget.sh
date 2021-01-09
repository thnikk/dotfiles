#!/usr/bin/env sh
# vim: filetype=sh

# Shget - A simple RSS torrent loader for POSIX-compliant shells
# It will read through all config files in ~/.config/shget/ and
# automatically download all new torrents matching the names in
# the config from a given feed and download them into a subdirectory
# named after the matching name.

# Don't change this yet, but transmission is way faster than deluge
DLDIR=$HOME/Downloads # Default download directory
CONFIGDIR=$HOME/.config/shget # Config directory
CACHEDIR=$HOME/.cache/shget # Cache directory

# Don't change this yet, but transmission is way faster than deluge
# Probably makes most sense to default to transmission but allow different client through arg
TCLIENT=transmission-daemon

# Counter for appending to cache filenames
count=0

# Use for loop to iterate through each config file in ~/.config/bashget
for f in $CONFIGDIR/*; do
    CONFIG=$f # Config file
    FEEDCACHE=$CACHEDIR/feed${count} # Output of RSS feed saved to file
    DLFILE=$CACHEDIR/downloaded${count} # All downloaded torrent URLs are saved here

    # Exit script if torrent client is not installed or running
    if [ ! "$(which $TCLIENT)" ]; then
        echo "$TCLIENT is not installed."
        exit 1
    fi
    if [ ! "$(pgrep "transmission-da")" ]; then
        echo "Daemon is not running."
        exit 1
    fi

    # Create necessary files if they don't exist
    [ ! -d "$CONFIGDIR" ] && mkdir -p "$CONFIGDIR"
    [ ! -d "$CACHEDIR" ] && mkdir -p "$CACHEDIR"
    if [ ! -f "$CONFIG" ]; then
        {
            echo "## Example config"
            echo "# rss:https://nyaa.si/?page=rss&q=720p&c=0_0&f=0&u=HorribleSubs"
            echo "## path below must be absolute"
            echo "# path:$HOME/Videos/Anime"
            echo "# Shokugeki no Soma,Season 05"
            echo "## (Optional) Text after the comma will place the downloaded files into a subdirectory of the given name within the show directory. Alternatively, if there's only once season, just enter the name of the show: "
            echo "# Kakushigoto"
            echo "## Capitalization doesn't matter for matching, but the same names are used for the folder names. Exclude any non-letter or number characters, otherwise it can cause issues with folder names."
        } > "$CONFIG"
        echo "Please edit config file at $CONFIG"
        exit 1
    fi
    [ ! -f "$DLFILE" ] && touch "$DLFILE"

    # If the config file is empty, prompt the user to add feed and show
    if [ "$(grep -v "#" -c "$CONFIG")" = 0 ]; then
        echo "Please edit your config file at $CONFIG"
    else
        # Pull feed from config
        FEED=$(grep -v "#" "$CONFIG" | grep "rss:" | awk -F"rss:" '{print $NF}')
        DLDIR=$(grep -v "#" "$CONFIG" | grep "path:" | awk -F"path:" '{print $NF}')
        # Save output to cache file
        curl -s "$FEED" > "$FEEDCACHE"

        while read -r LINE; do
            # Exclude empty, feed, and commented lines
            echo "$LINE" | grep -q ':\|#' || [ -z "$LINE" ] && continue
            # Separate directory if specified
            ODIR="$(echo "$LINE" | awk -F"," '{print $2}')"
            LINE=$(echo "$LINE" | awk -F"," '{print $1}')
            echo "$LINE:"
            # Pull download links from RSS feed (separated by a space if more than one)
            GLINE="$(echo "$LINE" | sed 's/ /.*/g')" # This makes grep lazier so it only searches for words in the title
            LINKS=$(grep -w -i -A 1 "$GLINE.*title" "$FEEDCACHE" | sed '/[bB]atch/,+1d' | grep "link" | sed -e "s/<[^<>]*>//g;s/^[ \t]*//" | tr '\n' ' ')
            NUMLINKS=$(echo "$LINKS" | awk '{print NF}') # Check number of links
            FDIR="$DLDIR/$LINE" # Directory to save show to
            [ -z "$ODIR" ] || FDIR="$FDIR/$ODIR" # Add opt dir if present
            echo "  $NUMLINKS episode(s) found in feed" # Echo number of links for show


            # Iterate through links
            i=1
            while [ "$i" -le "$NUMLINKS" ]; do
                # Single out link
                SLINK=$(echo "$LINKS" | awk -F' ' -v i="$i" '{print $i}')
                # Echo link to file if it doesn't exist and add torrent to transmission
                if ! grep -q "$SLINK" "$DLFILE" || [ "$FORCE" = "1" ]; then
                    #echo "$SLINK"
                    echo "$FORCE"
                    transmission-remote -a -w "$FDIR" "$SLINK" && echo "$SLINK" >> "$DLFILE"
                else
                    echo "      Episode already downloaded"
                fi
                i=$(( i+1 ))
            done

        done < "$CONFIG"
    fi

    # Increment counter for naming cache files
    count=$(( count+1 ))
done
