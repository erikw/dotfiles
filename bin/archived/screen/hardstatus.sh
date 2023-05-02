#!/bin/bash
# Prints customized single-line system stats in the screens hardstatusbar

#INTIP=`ifconfig eth0 | grep Mask | cut -d: -f2 | cut -d " " -f1`
INTIP=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
#EXTIP=`cat /tmp/extip.txt`
#EXTIP=`wget -O - http://whatismyip.org/ 2>/dev/null`
#EXTIP=`curl --max-time 1 -s dns.loopia.se/checkip/checkip.php |sed 's/^.*: \([^<]*\).*$/\1/'`
#EXTIP=$(wget --timeout=2 --tries=1 -O - http://www.showmyip.com/simple/ 2>/dev/null)
if [ -f "/tmp/wan_ip.txt" ]; then
	EXTIP=$(cat /tmp/wan_ip.txt)
else
	EXTIP=$(wget --timeout=1 --tries=1 -O - http://formyip.com/ 2>/dev/null | grep -Pzo "(?<=Your IP is )[^<]*")
	if [ "$?" -eq 0 ]; then
		echo "${EXTIP}" > /tmp/wan_ip.txt
	fi
fi
UPTIME=`uptime | cut -d ' ' -f 5 | sed -e 's/^\(.*\).$/\1/'`
#NP=`mpc --host -h rJotJsq2996iZjWFxCiJEqGeAYh_hnNq@localhost --format "%artist%\n%title%" | grep -PZo '^(.|\n)*?(?=\[)' | sed ':a;N;$!ba;s/\n/ - /g' | sed 's/\s*-\s$//' | cut -c1-50`
NP=`/home/erikw/dev/tmux-powerline/segments/mpd_np.sh |  cut -c2-`
echo -n "intIP: $INTIP | extIP: $EXTIP | Up: $UPTIME | NP: $NP"
