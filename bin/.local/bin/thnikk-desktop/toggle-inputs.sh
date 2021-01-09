#!/bin/bash

ACTIVE="$(sudo ddcutil getvcp 60 --sn C8LMTF091196)"
echo "$ACTIVE"

if [ "$(sudo virsh list --name | wc -l)" -gt 1 ]; then
    case "$ACTIVE" in
        *"DisplayPort-1"*)
            notify-send "Setting output to HDMI"
            sudo ddcutil setvcp 60 0x11 --sn C8LMTF091196 &
            if pgrep sway; then
                swaymsg output DP-3 disable
            else
                xrandr --output DisplayPort-0 --off --output DisplayPort-1 --mode 3840x2160 --pos 0x0 --rotate normal --output DisplayPort-2 --off --output HDMI-A-0 --off
            sleep 1
            feh --bg-fill ~/.config/wall.png
            fi
            ;;
        *"HDMI-1"*)
            notify-send "Setting output to DisplayPort"
            sudo ddcutil setvcp 60 0x0f --sn C8LMTF091196 &
            if pgrep sway; then
                swaymsg output DP-3 enable
            else
                xrandr --output DisplayPort-0 --off --output DisplayPort-1 --primary --mode 3840x2160 --pos 2560x0 --rotate normal --output DisplayPort-2 --mode 2560x1440 --pos 0x720 --rotate normal --output HDMI-A-0 --off
                sleep 1
                feh --bg-fill ~/.config/wall.png ~/.config/wall2.png
            fi
            ;;
    esac
    i3-msg workspace number 2
    i3-msg workspace number 1
else
    sudo ddcutil setvcp 60 0x0f --sn C8LMTF091196 &
    if pgrep sway; then
        swaymsg output DP-3 enable
    else
        xrandr --output DisplayPort-0 --off --output DisplayPort-1 --primary --mode 3840x2160 --pos 2560x0 --rotate normal --output DisplayPort-2 --mode 2560x1440 --pos 0x720 --rotate normal --output HDMI-A-0 --off
        sleep 1
        feh --bg-fill ~/.config/wall.png ~/.config/wall2.png
    fi
fi
