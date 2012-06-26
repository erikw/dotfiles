#!/bin/bash
# This script will first prepare and then start an instance of screen called irctor.

# Delete rtorrent.lock if it exists
if [ -f ~/sl/.sessions/rtorrent.lock ]; then
	rm -f ~/dl/.sessions/rtorrent.lock
fi

# Delete octave-core if it exists
if [ -f ~/octave-core ]; then
	rm -f ~/octave-core
fi

# Write external IP-address to file for the hardstatusbar in screen to use.
#wget -O - http://whatismyip.org/ 2>/dev/null > /tmp/extip.txt

# Start screen in "detached" mode with a special configuration file.
screen -dm -c ~/.screenrc.irctor

