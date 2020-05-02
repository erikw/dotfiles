#!/usr/bin/env bash
# Concatenate accesslog so I can inspect with goaccess(1).
# To be run as a cronjob before midnight where logs are rotated:
# 0     0     *     *     *      uberspace_collect_access_log.sh

log_src=$HOME/logs/webserver/access_log
log_all=$HOME/logs/www_access_log_all

#cat $log_src >> $log_all
# Be sure to only collect new lines AND that we don't miss entries that was added past midnight but before the logs was truncated (around 3am it seems)
# Reference: https://stackoverflow.com/a/15384897/265508
touch $log_all
cat webserver/access_log.1 webserver/access_log | diff -u www_access_log_all - | grep '^\+' | sed -E 's/^\+//' | tail -n +2 >> www_access_log_all
