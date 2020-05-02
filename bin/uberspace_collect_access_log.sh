#!/usr/bin/env bash
# Concatenate accesslog so I can inspect with goaccess(1).
# To be run as a cronjob before midnight where logs are rotated:
# 0     0     *     *     *      uberspace_collect_access_log.sh

log_today=$HOME/logs/webserver/access_log
log_yesterday=$HOME/logs/webserver/access_log.1
log_all=$HOME/logs/www_access_log_all


#cat $log_today >> $log_all

# Be sure to only collect new lines AND that we don't miss entries that was added past midnight but before the logs was truncated (around 3am it seems)
# Reference: https://stackoverflow.com/a/15384897/265508
test -e $log_all || touch $log_all
cat $log_yesterday $log_today | diff -u $log_all - | grep '^\+' | sed -E 's/^\+//' | tail -n +2 >> $log_all
