#!/usr/bin/env sh

HOSTNAME="$(cat /etc/hostname)"

echo "$HOSTNAME"
if [ "$HOSTNAME" = "thnikk-desktop" ]; then
    echo "Starting desktop applications..."
    i3-msg 'workspace 2; append_layout ~/.config/i3/workspace2.json' &
    kitty -o font_size=10 --title ncmpcpp ncmpcpp &
    kitty -o font_size=6 --title cava cava &
    telegram-desktop &
    discord &
    i3-msg 'workspace 1' &
else
    echo "Not on desktop, closing."
fi
