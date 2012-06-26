#!/usr/bin/env sh
# Keep that crash-y dunst running...
# Kill with $(pkill -f dunst_restarter)

logf=$HOME/.log/dunst.log
while :; do
    dunst 2>&1 >> $logf
    echo "$(date +'%F %T') $0 crashed, will restart" >> $logf
    sleep 5
done
