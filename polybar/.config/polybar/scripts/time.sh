#!/bin/bash

DATE=$(date +%a,\ %b\ %-d)
DAY=$(date +%d)

case $DAY in
    *11 | *12 | *13 ) EXTRA="th"
        ;;
    *1) EXTRA="st"
        ;;
    *2) EXTRA="nd"
        ;;
    *3) EXTRA="rd"
        ;;
    *) EXTRA="th"
        ;;
esac

echo "$DATE$EXTRA"
