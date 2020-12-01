#!/bin/bash
# This script will symlink the userchrome folder into your firefox profile. The profile must already exist.


# Add checks to see if existing files are links.
for d in "$HOME"/.mozilla/firefox/*.*; do
    if [ -d "$d" ]; then
        echo "Creating symlinks for profile at $d"
        if [ -d "$d/chrome" ]; then
            echo "Existing chrome folder found. Moving to chrome.old"
            mv "$d/chrome" "$d/chrome.old"
        fi
        if [ -f "$d/user.js" ]; then
            echo "Existing user.js found. Moving to user.js.old"
            mv "$d/user.js" "$d/user.js.old"
        fi
        ln -s "$HOME/.config/firefox/themes/min_nopad/chrome" "$d"
        ln -s "$HOME/.config/firefox/user.js" "$d"
    fi
done

