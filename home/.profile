#Profile file
# This file runs on login of the user.
# Environment variables independent of the shell should be set here.

# Set host variable
export HOST="$(cat /etc/hostname)"

# Default Programs
export EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="firefox"
export READER="zathura"
export COMPOSITOR="picom"
export LAUNCHER="rofi -show drun"
if [ "$HOST" = "thnikk-laptop" ]; then
    export WM="i3"
else
    export WM="i3"
fi
export FM="$TERMINAL lf"

# Make man more readable by adding colors
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Pfetch
export PF_INFO="ascii title os host kernel pkgs shell wm "
export PF_ASCII="linux"

# Enable Japanese keyboard
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT4_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export GLFW_IM_MODULE=ibus

# Set theme for QT apps
export QT_STYLE_OVERRIDE=adwaita
#export QT_QPA_PLATFORMTHEME=gtk2
export QT_AUTO_SCREEN_SCALE_FACTOR=1

# Clean home
export LESSHISTFILE="-"
export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"
export WGETRC="$HOME/.config/wget/wgetrc"
# Create wgetrc if it doesn't exist
[ ! -d "$HOME/.config/wget" ] && mkdir -p "$HOME/.config/wget"
[ ! -f "$WGETRC" ] && touch "$WGETRC"
export ZDOTDIR="$HOME/.config/zsh"

# Add to path
[ ! -d "$HOME/.local/bin/$HOST" ] && mkdir "$HOME/.local/bin/$HOST"
export PATH="$PATH:$HOME/.local/bin:~/.platformio/penv/bin:$HOME/.local/bin/$HOST"

# ssh
export SSH_KEY_PATH="$HOME/.ssh/rsa_id"

# language (just in case)
export LANG=en_US.UTF-8

# Start graphical environment on tty1 if not running
if [ "$WM" = "sway" ]; then
    [ "$(tty)" = "/dev/tty1" ] && ! pgrep -x sway >/dev/null && exec sway
else
    [ "$(tty)" = "/dev/tty1" ] && ! pgrep -x Xorg >/dev/null && exec startx
fi
