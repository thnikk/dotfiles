#!/bin/bash

MAXLENGTH="20"

SONG=$(mpc current --format %title%)
ARTIST=$(mpc current --format %artist%)
SONGLENGTH=$(echo $SONG | wc -m)
ARTISTLENGTH=$(echo $ARTIST | wc -m)
[[ $SONGLENGTH -gt $MAXLENGTH ]] && SONG=$(echo "$SONG" | cut -c -$MAXLENGTH ) && ELIPSE2='..'
[[ $ARTISTLENGTH -gt $MAXLENGTH ]] && ARTIST=$(echo "$ARTIST" | cut -c -$MAXLENGTH ) && ELIPSE='..'

echo "$ARTIST$ELIPSE - $SONG$ELIPSE2"
