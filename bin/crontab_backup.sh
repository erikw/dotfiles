#!/usr/bin/env sh
# Why not add this to cron...? Like:
# @monthly                       if_fail_do_notification bak_crontab.sh


dest=$HOME/bak/systems/$(hostname -s)/cron
output=$dest/$(date +%Y-%m-%d)_${USER}.crontab

test -e $dest || mkdir -p $dest
crontab -l > $output
echo $output
