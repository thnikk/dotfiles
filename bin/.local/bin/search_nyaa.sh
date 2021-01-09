#!/usr/bin/env sh

trap 'rm $HOME/.cache/nyaa' EXIT

SEARCH="$(rofi -dmenu)"
URL="https://nyaa.si/?page=rss&q=${SEARCH}&f=0"

echo "$URL"

curl -s "$URL" | xmllint --xpath '//item/title/text()|//item/link/text()' - > "$HOME/.cache/nyaa"

NAME="$(grep -v https "$HOME"/.cache/nyaa | rofi -dmenu)"
[ -z "$NAME" ] && exit 1

TORRENT="$(grep -F "$NAME" -A1 "$HOME/.cache/nyaa" | sed -n 2p)"

transmission-remote 10.0.0.29 -a "$TORRENT"

