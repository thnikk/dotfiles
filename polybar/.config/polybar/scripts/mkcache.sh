#!/usr/bin/dash

# Show help dialogue
[ $1 == "--help" ] && echo "Usage: mkcache.sh [name] [command] [interval]" && exit 0

NAME=$1
INTERVAL1=$3
OUTPUT=$2

# Create cache file if it doesn't exist
[ -f ~/.cache/$NAME ] ||
    echo "$OUTPUT" > ~/.cache/$NAME

# Take human readable time and convert it
case $INTERVAL1 in
    h|hours) INTERVAL2="%H";;
    m|minutes) INTERVAL2="%H:%M";;
    s|seconds) INTERVAL2="%H:%M:%S";;
    d|days | *) INTERVAL2="";;
esac

# Assign date command in var for nested double quotes (there's probably an easier way)
DATE=$(date "+%Y-%m-%d $INTERVAL2")

# If the last edit time doesn't match the current time, send output to the cache file.
[ $(echo "$(stat -c %y ~/.cache/$NAME 2>/dev/null )" | grep "$DATE") ] &&
	echo "$OUTPUT"  > ~/.cache/$NAME && echo "success"
