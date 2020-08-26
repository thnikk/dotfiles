#!/usr/bin/dash

#FULLDATE="$(date "+%I:%M %a %m-%d-%y")"
#TIME="$(echo "$FULLDATE" | awk '{print $1}')"
#DOW="$(echo "$FULLDATE" | awk '{print $2}')"
#DATE="$(echo "$FULLDATE" | awk '{print $3}')"
TIME="$(date "+%I:%M")"
DOW="$(date "+%a")"
DATE="$(date "+%m-%d-%y")"
SPACE=${1:-" "}

echo "$DOW $DATE $TIME"
