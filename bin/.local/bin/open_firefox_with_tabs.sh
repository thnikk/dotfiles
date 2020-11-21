#!/usr/bin/env sh
LAUNCH="${1:-firefox}"

$LAUNCH --new-window -url "etsy.com/your/shops/me/dashboard" \
    -url "tweetdeck.twitter.com" \
    -url "pixiv.net/en" \
    -url "amiami.com" \
    -url "10.0.0.20:5001" \
    -url "10.0.0.20:5003" \
    -url "10.0.0.20:5000" \
    -url "10.0.0.29:5000" \
    -url "10.0.0.29:5001" &

firefox --new-window "youtube.com" &
