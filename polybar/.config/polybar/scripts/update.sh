#/usr/bin/env sh

ping -c1 google.com >/dev/null 2>/dev/null || exit 1

# Check for updates once an hour
if [ "$(stat -c %y ~/.cache/updates 2>/dev/null | cut -d':' -f1)" != "$(date '+%Y-%m-%d %H')" ]; then
    # Check main repos and aur
    updates_arch=$(checkupdates 2> /dev/null | wc -l )
    updates_aur=$(yay -Qum 2> /dev/null | wc -l)
    echo $(( "$updates_arch"+"$updates_aur" )) > ~/.cache/updates
fi

updates=$(cat ~/.cache/updates)

if [ "$updates" -gt 0 ]; then
    echo "$updates"
else
    echo ""
fi
