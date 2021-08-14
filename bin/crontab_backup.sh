#!/usr/bin/env sh
# Why not add this to cron...? Like:
# @monthly                       if_fail_do_notification bak_crontab.sh


dest=$HOME/bak/systems/$(hostname -s)/cron
output=$dest/crontab.$USER_$(date +%Y-%m-%d)

test -e $dest || mkdir -p $dest
crontab -l > $output
echo
echo $output
