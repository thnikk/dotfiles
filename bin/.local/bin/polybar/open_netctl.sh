#!/bin/bash

if systemctl is-active --quiet iwd; then
    kitty --title="netctl" -o font-size=10 iwctl;
elif systemctl is-active --quiet NetworkManager; then
    kitty --title="netctl" -o font-size=10 nmtui;
else
    notify-send "Not using iwd or NetworkManager, no interface to open."
fi
