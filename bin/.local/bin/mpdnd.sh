#!/usr/bin/env sh

mpdnotify() {

    # Get all info at once
    FULLOUT="$(mpc -f '%title%//%artist%//%album%//%file%' | sed '1q')"
    STATUS="$(mpc | sed -n '2 p' | awk '{print $1}' | sed 's/\[//g;s/\]//g')"

    # Exit the script if music isn't playing
    [ "$STATUS" = "playing" ] || exit 1

    # First, check if the cover art is in the music directory
    # Get directory containing song
    CDIR="$HOME/Music/$(echo "$FULLOUT" | awk -F '//' '{print $4}' | awk 'BEGIN{FS=OFS="/"}{NF--; print}')"
    # Store name of first file containing over (for cover)
    CACHE="$(find "$CDIR" -name "*over*" | tail -n +1 | sed '1q' )"
    # If nothing is found with cover in the filename, just use the first jpeg.
    [ -z "$CACHE" ] && CACHE="$(find "$CDIR" -type f -exec file --mime-type {} \+ | awk -F: '{if ($2 ~/image\//) print $1}' | tail -n +1 | sed '1q' )"
    # If the variable is empty, try to pull the cover art from the file with ffmpeg
    if [ -z "$CACHE" ]; then
        echo "Cover art not found, checking for embedded art..."
        # Export embedded cover art here
        ECACHE="$HOME/.cache/embed.jpg"
        # Delete existing cover art
        rm -f "$ECACHE"
        # Pull cover art from playing file
        #ffmpeg -y -i "$HOME/Music/$(echo "$FULLOUT" | awk -F'//' '{print $4}')" "$ECACHE"
        exiftool -picture -b "$HOME/Music/$(echo "$FULLOUT" | awk -F'//' '{print $4}')" > "$ECACHE"
        COVER="$ECACHE"
    else
        # Otherwise, select the embedded file
        COVER="$CACHE"
    fi

    # Pull other info for notification
    TITLE="$(echo "$FULLOUT" | awk -F'//' '{print $1}')"
    ARTIST="$(echo "$FULLOUT" | awk -F'//' '{print $2}')"
    ALBUM="$(echo "$FULLOUT" | awk -F'//' '{print $3}')"

    CCOVER="$HOME/.cache/croppedCover.jpg"
    # Crop album art to 1:1
    rm "$CCOVER" 2>/dev/null
    magick "$COVER" -gravity center -crop 1:1 -resize 100x100 "$CCOVER" 2>/dev/null

    # Notify
    if [ -f "$CCOVER" ]; then
        notify-send.sh --replace-file="$HOME"/.cache/notify-id "$TITLE" "$ARTIST\n$ALBUM" -i "$CCOVER"
    else
        notify-send.sh --replace-file="$HOME"/.cache/notify-id "$TITLE" "$ARTIST\n$ALBUM"
    fi

}

# Update lastsong when starting to prevent notification showing when script starts
# LASTSONG="$(mpc | sed 1q)"

while true; do
    ## Check playing song
    #SONG="$(mpc | sed 1q)"
    ## If the playing song doesn't match what was playing during the last check, notify
    #if [ ! "$SONG" = "$LASTSONG" ]; then
        #echo "Now playing: $SONG"
        #mpdnotify
    #fi
    ## Update lastsong
    #LASTSONG="$SONG"
    ## Only check once per second
    #sleep 1;
    mpc idle player
    mpdnotify
done
