#!/usr/bin/env sh

# Check if stow is installed
which stow || exit

for d in *; do
    [ -d "$d" ] && stow "$d"
done
