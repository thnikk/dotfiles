#/usr/bin/env sh

error_exit(){ echo "$1" 1>&2; exit 1; }
which stow &>/dev/null || error_exit "Stow is not installed."

for d in *; do
    [ -d $d ] && stow $d
done
