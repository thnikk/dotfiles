#!/bin/bash

for f in *.mp3; do
    TITLE="$(eyeD3 "$f" | grep title | sed 's/<[^<>]*>//g;s/^[ \t]*//;s/【[^【】]*】//g' | awk -F'／' '{print $1}' | awk -F'title: ' '{print $2}')"
    ARTIST="$(eyeD3 "$f" | grep artist | sed 's/<[^<>]*>//g;s/^[ \t]*//;s/【[^【】]*】//g' | awk -F'／' '{print $1}' | awk -F'artist: ' '{print $2}')"
    eyeD3 "$f" -t "$TITLE" -a "$ARTIST"
done
