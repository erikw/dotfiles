#!/bin/sh
# Announce current song playing in mpd in a KDE notification.

# Icon support for passivepopup is implemented in more recent versions of KDE.
#path=`mpc -f %file% | head -n1 | sed 's/\(.*\)\/.*\..\+$/~\/mult\/music\/\1/'`
#icon=`find $path  -type f -iregex '.*\.\(png\|jpg\|jpeg\|gif\|bmp\)$' -print | head -n1`
#kdialog --icon "$icon" --title "Currently playing song" --passivepopup "$np" 3

#np=`mpc --format "%title%[\n%album%]\n%artist%" | head -n3`
np=$(mpc --format "%title%[\n%album%]\n%artist%" | grep -Pzo '^(.|\n)*?(?=\[)')
kdialog --title "Currently playing song" --passivepopup "$np" 3
