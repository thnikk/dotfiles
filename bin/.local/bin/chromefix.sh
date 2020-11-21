#!/bin/bash
# Fixes chrome asking about restoring previous session

# Check for any chrome or chromium folder
for d in ~/.config/*chrom*; do
    sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' $d/'Local State'
    sed -i 's/"exited_cleanly":false/"exited_cleanly":true/; s/"exit_type":"[^"]\+"/"exit_type":"Normal"/' $d/Default/Preferences
done
