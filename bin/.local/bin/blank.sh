#!/usr/bin/env sh
# xset dpms force off doesn't like to work reliably, so this script
# will continuously run the command and wait for a keyboard input to
# stop. Do NOT run this outside of a terminal or there will be no way
# to stop it, unless you make a keybind to kill the script, which will
# require an explicitly set keybind instead of any keyboard input.

if [ -t 0 ]; then
    SAVED_STTY="$(stty --save)"
  stty -echo -icanon -icrnl time 0 min 0
fi

count=0
keypress=''
while [ "x$keypress" = "x" ]; do
  count=$(( count+1 ))
  xset dpms force off
  #echo -ne $count'\r'
  keypress="$(cat -v)"
done

if [ -t 0 ]; then stty "$SAVED_STTY"; fi

#echo "You pressed '$keypress' after $count loop iterations"
echo "Key '$keypress' received. Waking display..."
exit 0
