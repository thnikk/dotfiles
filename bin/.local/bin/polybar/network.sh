#!/usr/bin/env sh

iwgetid -r || hostname -i | grep -v "127.0.0.1\|127.0.0.2" | awk '{print $1}' | grep . || echo "Disconnected"
