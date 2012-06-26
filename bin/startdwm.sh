#!/usr/bin/env sh
# Allow restart of DWM with out affecting other apps.
# Kill with $(pkill -f startdwm)

while :; do
    dwm 2> $HOME/.log/dwm.log
done
