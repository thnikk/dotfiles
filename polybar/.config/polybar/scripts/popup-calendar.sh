#!/bin/sh

YAD_WIDTH=200
YAD_HEIGHT=200
BOTTOM=false
DATE="$(date +"%a %d %H:%M")"
WIDTH=$(xrandr | grep "Screen 0" | uniq | tr -d ',' | awk '{print $8}')
HIGHT=$(xrandr | grep "Screen 0" | uniq | tr -d ',' | awk '{print $10}')

case "$1" in
    --popup)
        eval "$(xdotool getmouselocation --shell)"

        : $(( pos_y = HEIGHT - 50 ))
        : $(( pos_x = WIDTH - YAD_WIDTH - 50 ))

        yad --calendar --undecorated --fixed --close-on-unfocus --no-buttons \
            --width=$YAD_WIDTH --height=$YAD_HEIGHT --posx=$pos_x --posy=$pos_y \
            > /dev/null
        ;;
    *)
        echo "$DATE"
        ;;
esac
