#!/usr/bin/python

# This script requires i3ipc-python package (install it from a system package manager
# or pip).
# It adds icons to the workspace name for each open window.
# Set your keybindings like this: set $workspace1 workspace number 1
# Add your icons to WINDOW_ICONS.
# Based on https://github.com/maximbaz/dotfiles/blob/master/bin/i3-autoname-workspaces

import argparse
import i3ipc
import logging
import re
import signal
import sys
import fontawesome as fa

WINDOW_ICONS = {
    'kitty': fa.icons['terminal'],
    'google-chrome': fa.icons['chrome'],
    'chromium': fa.icons['chrome'],
    'spotify': fa.icons['spotify'],
    'firefox': fa.icons['firefox'],
    'firefoxdeveloperedition': fa.icons['firefox'],
    'sxiv': fa.icons['images'],
    'zathura': fa.icons['file'],
    'feh': fa.icons['images'],
    'gimp': fa.icons['image'],
    'gimp-2.10': fa.icons['image'],
    'org.gnome.nautilus': fa.icons['folder-open'],
    'nemo': fa.icons['folder-open'],
    'steam': fa.icons['steam'],
    'telegram-desktop': fa.icons['telegram-plane'],
    'telegramdesktop': fa.icons['telegram-plane'],
    'processing-app-base': fa.icons['code'],
    'discord': fa.icons['comment-alt'], # Discord icon is broken on waybar
    'looking-glass-client': fa.icons['desktop'],
    'cura': fa.icons['align-right'],
    'prusa-slicer': fa.icons['align-left'],
    'mpv': fa.icons['play'],
    'pavucontrol': fa.icons['volume-up'],
    # Terminal entries
    'ncmpcpp': fa.icons['music'],
    'neomutt': fa.icons['envelope-open'],
    'cava': fa.icons['chart-bar'],
}

TERMINAL_PROGRAMS = {
    'ncmpcpp',
    'neomutt',
    'cava',
}

DEFAULT_ICON = fa.icons['asterisk']


def icon_for_window(window):
    app_id = window.app_id
    name = window.name
    # xwayland support
    window_class = window.window_class
    print("class:%s xwayland-class:%s name:%s"%(app_id,window_class,name))
    # If an app id exists...
    if app_id is not None and len(app_id) > 0:
        # Force lowercase
        app_id = app_id.lower()
        # If the app id is kitty and the title is in TERMINAL_PROGRAMS
        if app_id == "kitty" and name in TERMINAL_PROGRAMS:
            # print("There's a terminal program running.")
            # print(name)
            # Return the icon for the name
            return WINDOW_ICONS[name]
        # Otherwise
        elif app_id in WINDOW_ICONS:
            # Return the icon for the app id
            return WINDOW_ICONS[app_id]
        elif name in WINDOW_ICONS:
            # Return the icon for the app id
            return WINDOW_ICONS[name]
        logging.info("No icon available for window with app_id: %s" % str(app_id))
    else:
        # If the program is using xwayland, check the class instead
        if len(window_class) > 0:
            # Force lowercase
            window_class = window_class.lower()
            # If the class is contained in WINDOW_ICONS
            if window_class in WINDOW_ICONS:
                # Use the icon for the associated class
                return WINDOW_ICONS[window_class]
            logging.info(
                "No icon available for window with class_name: %s" % str(window_class)
            )
    # If all else fails or something goes unmatched, use the default icon
    return DEFAULT_ICON

def remove_dupes(string):
    s = set()
    list = []
    for ch in string:
        if ch not in s:
            s.add(ch)
            list.append(ch)
            list.append(' ')

    return ''.join(list)

def rename_workspaces(ipc):
    for workspace in ipc.get_tree().workspaces():
        name_parts = parse_workspace_name(workspace.name)

        icon_tuple = ()
        for w in workspace:
            if w.app_id is not None or w.window_class is not None:
                icon = icon_for_window(w)
                if not ARGUMENTS.duplicates and icon in icon_tuple:
                    continue
                icon_tuple += (icon,)
        name_parts["icons"] = "  ".join(icon_tuple) + " "
        new_name = construct_workspace_name(name_parts)
        # Remove colon because it's ugly
        new_name = new_name.replace(':', '')
        # Remove spaces because they get re-added in dupe removal
        new_name = new_name.replace(' ', '')

        # Remove duplicates
        new_name = remove_dupes(new_name)

        # This is a dirty fix for removing trailing spaces for empty workspaces that have had their icons removed
        if (len(new_name) == 2):
            new_name = new_name.strip()

        ipc.command('rename workspace "%s" to "%s"' % (workspace.name, new_name))


def undo_window_renaming(ipc):
    for workspace in ipc.get_tree().workspaces():
        name_parts = parse_workspace_name(workspace.name)
        name_parts["icons"] = None
        new_name = construct_workspace_name(name_parts)
        ipc.command('rename workspace "%s" to "%s"' % (workspace.name, new_name))
    ipc.main_quit()
    sys.exit(0)


def parse_workspace_name(name):
    return re.match(
        "(?P<num>[0-9]+):?(?P<shortname>\w+)? ?(?P<icons>.+)?", name
    ).groupdict()


def construct_workspace_name(parts):
    new_name = str(parts["num"])
    if parts["shortname"] or parts["icons"]:
        new_name += ":"

        if parts["shortname"]:
            new_name += parts["shortname"]

        if parts["icons"]:
            new_name += " " + parts["icons"]

    return new_name


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="This script automatically changes the workspace name in sway depending on your open applications."
    )
    parser.add_argument(
        "--duplicates",
        "-d",
        action="store_true",
        help="Set it when you want an icon for each instance of the same application per workspace.",
    )
    parser.add_argument(
        "--logfile",
        "-l",
        type=str,
        default="/tmp/sway-autoname-workspaces.log",
        help="Path for the logfile.",
    )
    args = parser.parse_args()
    global ARGUMENTS
    ARGUMENTS = args

    logging.basicConfig(
        level=logging.INFO,
        filename=ARGUMENTS.logfile,
        filemode="w",
        format="%(message)s",
    )

    ipc = i3ipc.Connection()

    for sig in [signal.SIGINT, signal.SIGTERM]:
        signal.signal(sig, lambda signal, frame: undo_window_renaming(ipc))

    def window_event_handler(ipc, e):
        if e.change in ["new", "close", "move"]:
            rename_workspaces(ipc)

    ipc.on("window", window_event_handler)

    rename_workspaces(ipc)

    ipc.main()
