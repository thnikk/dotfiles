#!/bin/bash

# Kill programs
pkill -f sway-autoname
pkill -f transparency.py
pkill autotiling

# Restart
~/.local/bin/sway/transparency.py &
~/.local/bin/sway/sway-autoname-workspaces.py &
autotiling &
