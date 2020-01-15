#!/usr/bin/env python3
# Source: https://wiki.archlinux.org/index.php/Spotify
# Depends: playerctl

import sys, os

import gi
gi.require_version('Playerctl', '1.0')
from gi.repository import Playerctl, GLib
from subprocess import Popen

player = Playerctl.Player()

def on_track_change(player, e):
    track_info = 'Spotify: {artist} - {album} - {title}'.format(artist=player.get_artist(), album=player.get_album(), title=player.get_title())
    Popen(['notify-send', '--app-name', os.path.basename(sys.argv[0]), track_info])

player.on('metadata', on_track_change)

GLib.MainLoop().run()
