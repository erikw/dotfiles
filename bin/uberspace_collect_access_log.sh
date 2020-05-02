#!/usr/bin/env bash
# Concatenate accesslog so I can inspect with goaccess(1).
# To be run as a cronjob before midnight where logs are rotated.

log_src=$HOME/logs/webserver/access_log
log_all=$HOME/logs/www_access_log_all

cat $log_src >> $log_all
