#!/usr/bin/env bash
# Notification queue example using terminal-notifier
# $ brew install terminal-notifier
#
# Now any program can just log important lines to the queu like
# do-stuff | other-stuff >> $HOME/.cache/notification-queue
set -euo pipefail

# A FIFO pipe file (not a regular file)
QUEUE=$HOME/.cache/notification-queue

basedir=$(dirname "$QUEUE")

test -d "$basedir" || mkdir -p "$basedir"
test -e "$QUEUE"  || mkfifo "$QUEUE"

while [[ -e "$QUEUE" ]]; do
  while read line; do
    terminal-notifier -title 'Notification Queue' -g notificationqueue -message "$line"
    sleep 5
  done < "$QUEUE"
done
