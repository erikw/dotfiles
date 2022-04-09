#!/bin/sh
# This script will check your current IP-address and update your domains DNS with it.

# Get current ip adress
newip=`curl -s dns.loopia.se/checkip/checkip.php | sed 's/^.*: \([^<]*\).*$/\1/'`

# Update cpt.erikw.me
curl -s --user 'erikw.me:GIT-CENSORED' "https://dns.loopia.se/XDynDNSServer/XDynDNS.php?hostname=hood.erikw.me&myip="$newip; echo
