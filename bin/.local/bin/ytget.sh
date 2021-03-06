#!/bin/bash
# vim: filetype=sh

CACHEDIR="$HOME/.cache/ytget"
CACHE="$CACHEDIR/cache"
DLFILE="$CACHEDIR/downloaded"

# Check if 2 args are given, otherwise quit
if [ "$#" -lt 1 ]; then
    echo "Usage: ytget <playlist url> <dir (optional)>"
    exit
fi

[ -d "$CACHEDIR" ] || mkdir -p "$CACHEDIR"
[ -f "$DLFILE" ] || touch "$DLFILE"

curl -s "https://www.youtube.com/feeds/videos.xml?playlist_id=$(echo "$1" | awk -F '=' '{print $NF}')" | grep -E 'title|link|name' | grep -v 'media' | grep '>'> "$CACHE"

ALBUM="$(sed -n '2p' < "$CACHE" | sed -e "s/<[^<>]*>//g;s/^[ \t]*//" | awk -F '/' '{print $1}')"
ARTIST="$(grep "name" "$CACHE" | sed -e "s/<[^<>]*>//g;s/^[ \t]*//" | head -1)"

echo "Album: $ALBUM"
echo "Artist: $ARTIST"

TITLE=""
TAGTITLE=""
LINK=""
DIR=${2:-$HOME/Downloads/$ARTIST-$ALBUM}
echo "Downloading to $DIR"
mkdir -p "$DIR"

while IFS= read -r line; do
    if [[ "$line" == *"link"* ]]; then
        # This is the link
        LINK="$(echo "$line" | awk -F '"' '{print $4}')"

        # Download
        if ! grep -q "$TITLE" "$DLFILE"; then
            youtube-dlc --extract-audio --audio-format mp3 --audio-quality 0 -o "$DIR/$TITLE.%(ext)s" -i "$LINK"
            eyeD3 -t "$TAGTITLE" -a "$ARTIST" -A "$ALBUM" "$2/$TITLE.mp3"
        fi
        echo "$TITLE" >> "$DLFILE"
    else
        # This is the title
        TITLE="$(echo "$line" | sed -e 's/<[^<>]*>//g;s/^[ \t]*//;s/【[^【】]*】//g')"
        # Strip the / from the title
        if [[ "$TITLE" == *"／"* ]]; then
            # Prefer ／
            TITLE="$(echo "$TITLE" | awk -F "／" '{print $1}')"
        elif [[ "$TITLE" == *"/"* ]]; then
            TITLE="$(echo "$TITLE" | awk -F "/" '{print $1}')"
        fi
        # After stripped, remove any outside spaces
        TITLE="$(echo "$TITLE" | sed 's/^[ \t]*//;s/[ \t]*$//')"

        TAGTITLE="$TITLE"
        TITLE="$(echo "$TITLE" | sed 's/\//\-/g')"
    fi

done < <( sed '1,2d' < "$CACHE" | grep -v "name" )
