#!/usr/bin/env bash
# Control the volume with a nice notification.

scriptname=${0##*/}
usage="Usage: ${scriptname} -c {up|down|mute} [-i increment] [-m mixer]"
increment="5%"
mixer="Master"

is_muted() {
	if (amixer get Master | grep "\[off\]" >/dev/null); then
		echo "true"
	else
		echo "false"
	fi
}
muted="$(is_muted)"


if [ "$#" -eq 0 ]; then
	echo "$usage"
	exit 2
fi

# getopts documentation: https://www.gnu.org/software/libc/manual/html_node/Using-Getopt.html
while getopts ":c:i:m:h?" opt; do
	case "$opt" in
		c) cmd="$OPTARG";;
		i) increment="$OPTARG";;
		m) mixer="$OPTARG";;
		:) echo "Option -$OPTARG requires an argument." >&2; exit 1;;
		h|?|*) echo "$usage"; exit 0;;
	esac
done
shift $(($OPTIND - 1))

if [ "$cmd" = "up" ]; then
	display_volume=$(amixer set $mixer $increment+ unmute | grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
	muted="false"
elif [ "$cmd" = "down" ]; then
	display_volume=$(amixer set $mixer $increment- | grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
elif [ "$cmd" = "mute" ]; then
	if [ "$muted" = "false" ]; then
		display_volume=$(amixer get $mixer 2>/dev/null| grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
		amixer set $mixer mute
		muted="true"
	else
		display_volume=$(amixer set $mixer unmute | grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
		muted="false"
	fi
else
	echo "Unknow command \"$cmd\"." 1>&2
	exit 3
fi

if [ "$muted" = "true" ]; then
	volnoti-show -m "$display_volume"
else
	volnoti-show "$display_volume"
fi
