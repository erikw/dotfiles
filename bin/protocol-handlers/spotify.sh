#!/bin/bash
# Open Spotify URI:s.
# KDE: Make ~/.kde4/share/kde4/services/spotify.protocol use this script.
# Gnome:
#$ gconftool-2 -s /desktop/gnome/url-handlers/spotify/command '/path/to/this/script %s' --type String
#$ gconftool-2 -s /desktop/gnome/url-handlers/spotify/enabled --type Boolean true

#wine "$HOME/.wine/drive_c/Program Files/Spotify/spotify.exe" /uri "$1"
/usr/bin/spotify -uri "$1"
