#!/usr/bin/dash
# POSIX compliant, change shell to whatever you'd like.
# Simple demo volume control script module for Polybar
# Reqiures pamixer.

# Get current volume
VOL="$(pamixer --get-volume)"
MUTE="$(pamixer --get-mute)"
# Desired width of module
WIDTH="5"
# Multiply volume by this value
SVM="$(( 100 / WIDTH ))"

# Volume expressed as 0-$WIDTH
OUTPUT="%{A1:pamixer -t:}"
if [ "$VOL" -gt "0" ] && [ "$MUTE" != "true" ]; then
    SV="$(( VOL / SVM ))"
else
    SV="0"
fi

# Change prefix based on mute status
# [ "$MUTE" != "true" ] && OUTPUT="${OUTPUT}V: " || OUTPUT="${OUTPUT}M: "
OUTPUT="${OUTPUT}%{A}"

VOLCOUNT=1
while [ "$VOLCOUNT" -le "$WIDTH" ]; do
    # Get volume setting for current run through loop
    VOLSET="$(( SVM * VOLCOUNT ))"
    # Add click handler opening tag with appropriate volume setting
    OUTPUT="${OUTPUT}%{A1:pamixer --set-volume $VOLSET:}"
    # If volume is greater than or equal to the count value, use =, otherwise use -
    if [ "$VOLCOUNT" -le "$SV" ]; then
        OUTPUT="${OUTPUT}="
    else
        OUTPUT="${OUTPUT}-"
    fi
    # Add click handler closing tag
    OUTPUT="${OUTPUT}%{A}"
    # Iterate through loop
    VOLCOUNT="$(( VOLCOUNT + 1 ))"
done

# Echo output wrapped in scroll handlers
echo "[%{A5:pamixer -d 10:}%{A4:pamixer -i 10:}$OUTPUT%{A}%{A}]"
