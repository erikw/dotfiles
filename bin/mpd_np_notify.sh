#!/bin/sh
# Announce current song playing in mpd over libnotify.

np=$(mpc --format "%artist%[ - %album%] - %title%" | grep -Pzo '^(.|\n)*?(?=\[)')
notify-send --app-name "mpd_np_notify.sh"  "MPD NP:" "$np" 
