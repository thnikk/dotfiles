#!/bin/bash
ls ~/.cache/stream_notify/live | rofi -dmenu | xargs -I {} xdg-open "https://twitch.tv/{}"
