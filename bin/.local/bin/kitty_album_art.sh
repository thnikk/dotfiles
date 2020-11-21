#!/bin/bash

COVER=/tmp/kunst.jpg
MUSIC_DIR=~/Music/
SIZE=250x250
POSITION="+0+0"


show_help() {
printf "%s" "Lazy edit of Kunst that uses kitty's image viewing functionality to poorly display album art."
}


# Parse the arguments
options=$(getopt -o h --long position:,size:,music_dir:,version,silent,help -- "$@")
eval set -- "$options"

while true; do
    case "$1" in
        --size)
            shift;
            SIZE=$1
            ;;
        --position)
            shift;
            POSITION=$1
            ;;
        --music_dir)
            shift;
            MUSIC_DIR=$1
            ;;
        -h|--help)
		    show_help
			exit
            ;;
        --silent)
            SILENT=true
            ;;
        --)
            shift
            break
            ;;
    esac
    shift
done

# This is a base64 endcoded image which will be used if
# the file does not have an emmbeded album art.
# The image is an image of a music note
read -r -d '' MUSIC_NOTE << EOF
iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAJESURBVGhD7Zg/axRRFMVXAtpYphEVREKClnHfJI0MmReSfAC3tRejhaBgo70fwN7aD2BvEU0gfztbu5AqMxNjoVnvG87KZXy7z5m5dxLI/OCw8Pade+7M3n3Dbq+jo6OjY8RwMJhKk+hhlph3eRJ9w/LF5jCOr1PTj6jpD7mNjkjDkbDl4vFjpX87teZJlkSfSD9501zYfv5QJ1fyZHGexuJtZs12ZqMzX8NlwX4+nK3NXMutWaOm39Nd/u5rMCSUao80fjBNwY+p8Y+krNxQVaGsLsfWzFLYS2r4M30Rf5WbaCJE6OILlhIidPEFSwkRuviCpYQIXXzB1WX26bR6ky4v3OPriNCFB1YRHa079Pr6eKk/h1IFfA+WdOGBk+QeXtT0Ft3pV6e2fxf2f+AeLOnCA8tC0xv09H1xGi/cgWUi3I8lXXigEzX8u3gmWPP8JI5uYdt/w2thSRceSM0/zVfnb+CtWvB6WNJFOlC6XhDpQOl6QaQDpesFkQ6UrhdEOlC6XpA6gcPB/avumKXnxCadXHkha766tTr1GlE18CRZvEmN7nHfOMGiS5XA4mdmYg64Z5Jg06VKYHlEQoKtOVIz6zx8f0iwNUNyZt2F+3zjBFt9pGe22gWYFLb6lEckJNjGUmWEssR8ga0+0jNL9Z75fD7Rp7UOW32kZxb/1u37vFyUu+sODtjqozGzxaFADfprFM3vuD3Y3gytmf17LJPHXbgTNb5BWhe58yNan1lpWp9ZDVqdWS1am9mOjo7LRq/3B1ESKyYUVquzAAAAAElFTkSuQmCC
EOF


is_connected() {
	# Check if internet is connected. We are using api.deezer.com to test
	# if the internet is connected because if api.deezer.com is down or
	# the internet is not connected this script will work as expected
	if ping -q -c 1 -W 1 api.deezer.com >/dev/null; then
		connected=true
	else
        [ ! "$SILENT" ] && echo "kunst: unable to check online for the album art"
		connected=false
	fi
}


get_cover_online() {
	# Check if connected to internet
	is_connected

	if [ "$connected" == false ];then
		ARTLESS=true
		return
	fi

	# Try to get the album cover online from api.deezer.com
	API_URL="https://api.deezer.com/search/autocomplete?q=$(mpc current)" && API_URL=${API_URL//' '/'%20'}

	# Extract the albumcover from the json returned
	IMG_URL=$(curl -s "$API_URL" | jq -r '.playlists.data[0] | .picture_big')

	if [ "$IMG_URL" = '' ] || [ "$IMG_URL" = 'null' ];then
        [ ! "$SILENT" ] && echo "error: cover not found online"
		ARTLESS=true
	else
        [ ! "$SILENT" ] && echo "kunst: cover found online"
		curl -o "$COVER" -s "$IMG_URL"
		ARTLESS=false
	fi

}


update_cover() {
	# Extract the album art from the mp3 file and dont show the messsy
	# output of ffmpeg
	ffmpeg -i "$MUSIC_DIR$(mpc current -f %file%)" "$COVER" -y &> /dev/null

	# Get the status of the previous command
	STATUS=$?

	# Check if the file has a embbeded album art
	if [ "$STATUS" -eq 0 ];then
        [ ! "$SILENT" ] && echo "kunst: extracted album art"
		ARTLESS=false
	else
        DIR="$MUSIC_DIR$(dirname "$(mpc current -f %file%)")"
        [ ! "$SILENT" ] && echo "kunst: inspecting $DIR"

		# Check if there is an album cover/art in the folder.
		# Look at issue #9 for more details
        for CANDIDATE in "$DIR/cover."{png,jpg}; do
            if [ -f "$CANDIDATE" ]; then
                STATUS=0
                ARTLESS=false
                convert "$CANDIDATE" $COVER &> /dev/null
                [ ! "$SILENT" ] && echo "kunst: found cover.png"
            fi
        done
    fi

	if [ "$STATUS" -ne 0 ];then
        [ ! "$SILENT" ] && echo "error: file does not have an album art"
		get_cover_online
	fi

	# Resize the image to 250x250
	if [ "$ARTLESS" == false ]; then
		convert "$COVER" -resize "$SIZE" "$COVER" &> /dev/null
        [ ! "$SILENT" ] && echo "kunst: resized album art to $SIZE"
	fi

}

pre_exit() {
	# Get the proccess ID of kunst and kill it.
    # We are dumping the output of kill to /dev/null
    # because if the user quits sxiv before they
    # exit kunst, an error will be shown
    # from kill and we dont want that
	kill -9 "$(cat /tmp/kunst.pid)" &>/dev/null

}

main() {

    dependencies=(sxiv convert bash ffmpeg mpc jq mpd)
    for dependency in "${dependencies[@]}"; do
        type -p "$dependency" &>/dev/null || {
            echo "error: Could not find '${dependency}', is it installed?" >&2
            exit 1
        }
    done

    [ "$KUNST_MUSIC_DIR" != "" ] && MUSIC_DIR="$KUNST_MUSIC_DIR"
    [ "$KUNST_SIZE" != "" ] && SIZE="$KUNST_SIZE"
    [ "$KUNST_POSITION" != "" ] && POSITION="$KUNST_POSITION"

	# Flag to run some commands only once in the loop
	FIRST_RUN=true

	while true; do

		update_cover

		if [ "$ARTLESS" == true ];then
			# Dhange the path to COVER because the music note
			# image is a png not jpg
			COVER=/tmp/kunst.png

			# Decode the base64 encoded image and save it
			# to /tmp/kunst.png
			echo "$MUSIC_NOTE" | base64 --decode > "$COVER"
            # Add padding around image to match image size
            convert $COVER -background none -gravity center -extent $SIZE $COVER
		fi

        if [ ! "$SILENT" ];then
            echo "kunst: swapped album art to $(mpc current)"
            printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
        fi

        # Clear terminal
        printf '\E[H\E[3J'
        # Display image
        kitty +kitten icat --align center --scale-up -z 10 $COVER
        #kitty +kitten icat --place "25x25@0x0" --scale-up $COVER

        # Waiting for an event from mpd; play/pause/next/previous
		# this lets kunst use less CPU :)
		while true; do
		    mpc idle player &>/dev/null && (mpc status | grep "\[playing\]" &>/dev/null) && break
		done
        [ ! "$SILENT" ] && echo "kunst: received event from mpd"
	done
}

# Disable CTRL-Z because if we allowed this key press,
# then the script would exit but, sxiv would still be
# running
trap "" SIGTSTP

trap pre_exit EXIT
main
