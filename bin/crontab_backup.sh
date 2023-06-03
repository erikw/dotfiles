#!/usr/bin/env sh
# Tip: add this to cron like:
# @monthly                       if_fail_do_notification bak_crontab.sh


dest=$HOME/bak/systems/$(hostname -s)/cron
output=$dest/$(date +%Y-%m-%d)_${USER}.crontab

test -e $dest || mkdir -p $dest
crontab -l > $output
echo $output
