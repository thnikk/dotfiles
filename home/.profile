#Profile file
# This file runs on login of the user.
# Environment variables independent of the shell should be set here.

# Default Programs
export EDITOR="nvim"
export TERMINAL="kitty -1"
export BROWSER="firefox"
export READER="zathura"
export COMPOSITOR="picom-both --experimental-backends"
export LAUNCHER="rofi -show drun"
export WM="i3"
export FM="$TERMINAL lf"

# Enable Japanese keyboard
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT4_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export GLFW_IM_MODULE=ibus

# Set theme for QT apps
export QT_STYLE_OVERRIDE=GTK+
export QT_QPA_PLATFORMTHEME=gtk2

# Clean home
export LESSHISTFILE="-"
export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"
export WGETRC="$HOME/.config/wget/wgetrc"
export ZDOTDIR="$HOME/.config/zsh"

# Add to path
export PATH=$PATH:~/.local/bin:~/.platformio/penv/bin

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# language (just in case)
export LANG=en_US.UTF-8

# Start graphical environment on tty1 if not running
[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x Xorg >/dev/null && exec startx

