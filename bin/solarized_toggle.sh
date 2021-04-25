#!/usr/bin/env bash
# Toggle solarized between light and dark.

scriptname=${0##*/}
storage=$HOME/.solarizedtoggle
! [ -d $storage ] && mkdir $storage

statusfile=$storage/status
xres=$HOME/.Xresources
xres_symlink=$storage/Xresouces_theme
xres_dark=$HOME/.Xresources.solarized_dark
xres_light=$HOME/.Xresources.solarized_light


program_is_in_path() {
	local program="$1"
	type "$1" >/dev/null 2>&1
}

set_tmux() {
	local -n opts=$1
	local theme_conf=
	program_is_in_path tmux || return

	if [ "${opts[mode]}" =  dark ]; then
		theme_conf=$HOME/src/github.com/seebi/tmux-colors-solarized/tmuxcolors-dark.conf
	else
		theme_conf=$HOME/src/github.com/seebi/tmux-colors-solarized/tmuxcolors-light.conf
	fi
	tmux source $theme_conf
}

set_iterm2() {
	local -n opts=$1
	if [ -d /Applications/iTerm.app ]; then
		$HOME/bin/solarized_iterm2_set.py "${opts[mode]}"
	fi
}

set_xrdb() {
	local -n opts=$1
	([ -z $DISPLAY ] || !(program_is_in_path xrdb)) && return
	if [ "${opts[mode]}" =  dark ]; then
		ln -sf $xres_dark $xres_symlink
	else
		ln -sf $xres_light $xres_symlink
	fi
	xrdb -load $xres
}

# Normally this script will be called by macos_appearance_monitor.sh to update the rest of the system when the OS mode has been changed. With the give flag, this script can however change the sytem mode as well.
# BEWARE this will result in another call to this scrip, leading to a flickering (but right theme will eventually be set).
set_macos() {
	local -n opts=$1
	[ "${opts[macos_update]}" == true ] || return
	# Reference: https://brettterpstra.com/2018/09/26/shell-tricks-toggling-dark-mode-from-terminal/
	if [ "${opts[mode]}" =  dark ]; then
		osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true'
	else
		osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to false'
	fi
}

set_statusfile() {
	local -n opts=$1 # Refer to assoc array by name. Reference: https://stackoverflow.com/a/55170447/265508
	echo "${opts[mode]}" > $statusfile
}

read_status() {
	[ -e $statusfile ] && cat $statusfile || echo ""
}



usage="Usage: ${scriptname} [-m {dark|light}] [-o]"
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
	if  [ -e $statusfile ]; then
		opts_g[mode]=$([ $(read_status) = dark ] && echo light || echo dark)
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
set_statusfile opts_g
set_iterm2 opts_g
set_tmux opts_g
set_xrdb opts_g
set_macos opts_g
