#!/bin/bash

CACHE=~/.cache/animeSchedule
pullInfo(){
    curl -s https://myanimelist.net/anime/season/schedule | grep 'link-title\|anime-header' > $CACHE
}

DATEFILE=$(stat -c %y $CACHE | cut -d':' -f1)
DATE=$(date '+%Y-%m-%d')
DOW=$(date --date="+1 day" +%A)
DOWT=$(date --date="+2 day" +%A)
[[ "$DOW" == "Sunday" ]] && DOWT="Other"

[ -f $CACHE ] || pullInfo
[[ "$DATEFILE" != "$DATE"* ]] && pullInfo

cat $CACHE | sed -e "s/<[^<>]*>//g;s/^[ \t]*//;s/amp;//g;s/&#039;/'/g" | grep -A 9999 $DOW | grep -B 9999 $DOWT | grep -v $DOWT
