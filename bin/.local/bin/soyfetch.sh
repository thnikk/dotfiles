#!/usr/bin/env sh

KERNEL="$(uname -r)"
MODEL="$(cat /sys/devices/virtual/dmi/id/product_family)"
[ "$MODEL" = "To be filled by O.E.M." ] && MODEL="$(cat /sys/devices/virtual/dmi/id/board_name)"
[ "$(pgrep picom)" ] && COMP="$(yay -Q | grep -i 'picom' | awk '{print $1}')"
DISTRO="$(lsb_release -ds | sed 's/"//g')"
BAR="$(pgrep -l bar | awk '{print $2}')"
#WM="$(wmctrl -m | grep Name: | cut -d ' ' -f2)"

# Not tested with display managers, but this will pull the WM from pstree
if pstree | grep -q "login-.*+"; then
    WM="$(pstree | grep "login.*+" -A1 | sed -n 2p | awk -F'-' '{print $2}')"
else
    WM="$(pstree | grep "login-" | awk -F '---' '{print $2}')"
fi

printLine() {
    # Print first column
    printf "\e[34m%s:\e[39m\t" "$1"
    # Print extra tab if first column is less than 8 chars wide
    [ "${#1}" -le 7 ] && printf "\t"
    # Print second column
    printf "%s\n" "$2"
}

printLine "Distro" "$DISTRO"
printLine "Kernel" "$KERNEL"
printLine "Model" "$MODEL"
printLine "WM" "$WM"
[ -z "$BAR" ] || printLine "Bar" "$BAR"
[ -z "$COMP" ] || printLine "Compositor" "$COMP"
[ -z "$TERMINAL" ] || printLine "Terminal" "$( echo "$TERMINAL" | awk '{print $1}')"

printf "\n"
i=0
while [ $i -lt 8 ]; do
    printf "\e[3%sm \u2588\u2588 \e[0m" "$i"
    i=$(( i+1 ))
done
printf "\n\n"
