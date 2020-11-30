#!/bin/sh
# Sync mail and give notification if there is new mail.

# Required to display notifications if run as a cronjob:
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus
export DISPLAY=:0.0
# Required for playing sound
export XDG_RUNTIME_DIR="/run/user/1000"
SOUND="$HOME/.config/notifications/alert.ogg"

# Run only if user logged in (prevent cron errors)
pgrep -u "${USER:=$LOGNAME}" >/dev/null || { echo "$USER not logged in; sync will not run."; exit ;}
# Run only if not already running in other instance
pgrep -x mbsync >/dev/null && { echo "mbsync is already running." ; exit ;}

# Checks for internet connection and set notification script.
ping -q -c 1 1.1.1.1 > /dev/null || ping -q -c 1 1.0.0.1 > /dev/null || ping -q -c 1 example.org || { echo "No internet connection detected."; exit ;}
command -v notify-send >/dev/null || echo "Note that \`libnotify\` or \`libnotify-send\` should be installed for pop-up mail notifications with this script."

# For individual configurations:
[ -d "$HOME/.local/share/password-store" ] && export PASSWORD_STORE_DIR="$HOME/.local/share/password-store"

# Notifications
notify() {
    # Display general notification whenever new mail is received
    notify-send -i xfce-nomail -a mailsync "mutt-wizard" "$2 new mail(s) in \`$1\` account."
    # Play a sound if it exists
    [ -f "$SOUND" ] && paplay --volume=40000 "$SOUND"
}
messageinfo() {
    # Show email info in separate notification
    notify-send -i xfce-nomail -a mailsync "$from:" "$subject"
}


# Check account for new mail. Notify if there is new content.
syncandnotify() {
    acc="$(echo "$account" | sed "s/.*\///")"
    if [ -z "$opts" ]; then mbsync "$acc"; else mbsync "$opts" "$acc"; fi
    new=$(find "$HOME/.local/share/mail/$acc/INBOX/new/" "$HOME/.local/share/mail/$acc/Inbox/new/" "$HOME/.local/share/mail/$acc/inbox/new/" -type f -newer "$HOME/.config/mutt/.mailsynclastrun" 2> /dev/null)
    newcount=$(echo "$new" | sed '/^\s*$/d' | wc -l)
    if [ "$newcount" -gt "0" ]; then
        notify "$acc" "$newcount" &
        for file in $new; do
            # Extract subject and sender from mail.
            from=$(awk '/^From: / && ++n ==1,/^\<.*\>:/' "$file" | perl -CS -MEncode -ne 'print decode("MIME-Header", $_)' | awk '{ $1=""; if (NF>=3)$NF=""; print $0 }' | sed 's/^[[:blank:]]*[\"'\''\<]*//;s/[\"'\''\>]*[[:blank:]]*$//')
            subject=$(awk '/^Subject: / && ++n == 1,/^\<.*\>: / && ++i == 2' "$file" | head -n 1 | perl -CS -MEncode -ne 'print decode("MIME-Header", $_)' | sed 's/^Subject: //' | sed 's/^{[[:blank:]]*[\"'\''\<]*//;s/[\"'\''\>]*[[:blank:]]*$//' | tr -d '\n')
	    messageinfo &
        done
    fi
}

# Sync accounts passed as argument or all.
if [ "$#" -eq "0" ]; then
    accounts="$(awk '/^Channel/ {print $2}' "$HOME/.mbsyncrc")"
else
    for arg in "$@"; do
        [ "${arg%${arg#?}}" = '-' ] && opts="${opts:+${opts} }${arg}" && shift 1
    done
    accounts=$*
fi

( kill -46 "$(pidof "${STATUSBAR:-dwmblocks}")" >/dev/null 2>&1 ) 2>/dev/null

# Parallelize multiple accounts
for account in $accounts
do
    syncandnotify &
done

wait

notmuch new 2>/dev/null

emacsclient -e "(mu4e-update-index)" >/dev/null 2>&1 ||
    mu index

#Create a touch file that indicates the time of the last run of mailsync
touch "$HOME/.config/mutt/.mailsynclastrun"
