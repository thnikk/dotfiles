#!/usr/bin/python

# Simple python script that selectively applies transparency for specific windows. Compatible with both wayland and xwayland programs.

import i3ipc
import signal
import sys
from functools import partial
import time

PROGRAMS = {
        "discord",
        "telegramdesktop"
}

def get_name(w):
    if w.app_id is not None and len(w.app_id) > 0:
        name=w.app_id
        # print(name)
        return name
    elif w.window_class is not None and len(w.window_class) > 0:
        name=w.window_class
        # print(name)
        return name
    else:
        return

def set_all(transparency):
    for workspace in ipc.get_tree().workspaces():
        for w in workspace:
            name=get_name(w)
            if name in PROGRAMS:
                w.command("opacity %s" % transparency)

def remove_opacity(ipc):
    set_all("1")
    ipc.main_quit()
    sys.exit(0)


if __name__ == "__main__":

    ipc = i3ipc.Connection()

    set_all("0.9")

    def window_event_handler(ipc, e):
        if e.change in ["new"]:
            set_all("0.9")

    ipc.on("window", window_event_handler)

    for sig in [signal.SIGINT, signal.SIGTERM]:
        signal.signal(sig, lambda signal, frame: remove_opacity(ipc))
    ipc.main()
