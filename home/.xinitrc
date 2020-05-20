#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

# merge in defaults and keymaps
[ -f $sysresources ] && xrdb -merge $sysresources
[ -f $sysmodmap ] && xmodmap $sysmodmap
[ -f "$userresources" ] && xrdb -merge "$userresources"
[ -f "$usermodmap" ] && xmodmap "$usermodmap"

[ -f ~/.xprofile ] && ~/.xprofile

#case $WM in
    #i3) exec i3
        #;;
    #bspwm) exec bspwm
        #;;
#esac
exec $WM
