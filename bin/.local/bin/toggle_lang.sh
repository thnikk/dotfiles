#!/bin/sh

CURRENT="$(ibus engine)"

case $CURRENT in
    anthy) ibus engine xkb:us::eng
        dunstify "Switching keyboard language to English"
        ;;
    "xkb:us::eng") ibus engine anthy
        dunstify "Switching keyboard language to Japanese"
        ;;
esac
