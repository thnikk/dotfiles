#!/bin/bash
# This script will symlink the userchrome folder into your firefox profile. The profile must already exist.

for d in "$HOME"/.mozilla/firefox/*.*; do
    if [ -d "$d" ]; then
        echo "Creating symlinks for profile at $d"
        if [ -d "$d/chrome" ] && [ ! -L "$d/chrome" ]; then
            echo "Existing chrome folder found. Moving to chrome.old"
            mv "$d/chrome" "$d/chrome.old"
            ln -s "$HOME/.config/firefox/themes/min_nopad/chrome" "$d"
        elif [ -L "$d/chrome" ]; then
            echo "Link already exists for chrome"
        else
            ln -s "$HOME/.config/firefox/themes/min_nopad/chrome" "$d"
        fi
        if [ -f "$d/user.js" ] && [ ! -L "$d/user.js" ]; then
            echo "Existing user.js found. Moving to user.js.old"
            mv "$d/user.js" "$d/user.js.old"
            ln -s "$HOME/.config/firefox/user.js" "$d"
        elif [ -L "$d/user.js" ]; then
            echo "Link already exists for user.js"
        else
            ln -s "$HOME/.config/firefox/user.js" "$d"
        fi
    fi
done

