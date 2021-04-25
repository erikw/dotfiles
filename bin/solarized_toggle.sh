#!/usr/bin/env bash
# Toggle solarized between light and dark.

script_name=${0##*/}
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source ${script_dir}/solarized_toggle_lib.sh


usage="Usage: ${script_name} [-m {dark|light}] [-o]"
declare -A opts_g=( [mode]=unset [macos_update]=false)
while getopts ":m:oh?" opt; do
	case "$opt" in
		m) opts_g[mode]="$OPTARG";;
		o) opts_g[macos_update]="true";;
		:) echo "Option -$OPTARG requires an argument." >&2; exit 1;;
		h|?|*) echo "$usage"; exit 0;;
	esac
done
shift $(($OPTIND - 1))


if [ "${opts_g[mode]}" = unset ]; then
	if  [ -e $ST_STATUSFILE ]; then
		opts_g[mode]=$([ $(st_read_status) = dark ] && echo light || echo dark)
	else
		opts_g[mode]=light
	fi
else
	if !([ "${opts_g[mode]}" = dark ] || [ "${opts_g[mode]}" = light ]); then
		echo "mode must be either dark or light" >&2
		exit 1
	fi
fi

echo "${opts_g[mode]}"
st_set_statusfile opts_g
st_set_iterm2 opts_g
st_set_tmux opts_g
st_set_xrdb opts_g
st_set_macos opts_g
