# Functions etc. for solarize toggling, that can be sourced.

ST_STORAGE=$HOME/.solarizedtoggle
! [ -d $ST_STORAGE ] && mkdir $ST_STORAGE
ST_STATUSFILE=$ST_STORAGE/status


st_program_is_in_path() {
	local program="$1"
	type "$1" >/dev/null 2>&1
}

st_set_tmux() {
	local -n opts=$1
	local theme_conf=
	st_program_is_in_path tmux || return

	if [ "${opts[mode]}" =  dark ]; then
		theme_conf=$HOME/src/github.com/seebi/tmux-colors-solarized/tmuxcolors-dark.conf
	else
		theme_conf=$HOME/src/github.com/seebi/tmux-colors-solarized/tmuxcolors-light.conf
	fi
	tmux source $theme_conf
}

st_set_iterm2() {
	local -n opts=$1
	if [ -d /Applications/iTerm.app ]; then
		$HOME/bin/solarized_iterm2_set.py "${opts[mode]}"
	fi
}

st_set_xrdb() {
	local -n opts=$1

	local xres=$XDG_CONFIG_HOME/X11/Xresources
	local xres_symlink=$ST_STORAGE/Xresouces_theme
	local xres_dark=$XDG_CONFIG_HOME/X11/Xresources.solarized_dark
	local xres_light=$XDG_CONFIG_HOME/X11/Xresources.solarized_light
	([ -z $DISPLAY ] || !(st_program_is_in_path xrdb)) && return
	if [ "${opts[mode]}" =  dark ]; then
		ln -sf $xres_dark $xres_symlink
	else
		ln -sf $xres_light $xres_symlink
	fi
	xrdb -load $xres
}

# Normally this script will be called by macos_appearance_monitor.sh to update the rest of the system when the OS mode has been changed. With the give flag, this script can however change the sytem mode as well.
# BEWARE this will result in another call to this scrip, leading to a flickering (but right theme will eventually be set).
st_set_macos() {
	local -n opts=$1
	[ "${opts[macos_update]}" == true ] || return
	# Reference: https://brettterpstra.com/2018/09/26/shell-tricks-toggling-dark-mode-from-terminal/
	# Alternative: https://github.com/sindresorhus/dark-mode
	if [ "${opts[mode]}" =  dark ]; then
		osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true'
	else
		osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to false'
	fi
}

st_set_statusfile() {
	local -n opts=$1 # Refer to assoc array by name. Reference: https://stackoverflow.com/a/55170447/265508
	echo "${opts[mode]}" > $ST_STATUSFILE
}

st_read_status() {
	[ -e $ST_STATUSFILE ] && cat $ST_STATUSFILE || echo ""
}





# Read mode set by macOS
st_read_macos_mode() {
	local mode=
	#defaults read -g AppleInterfaceStyle >/dev/null 2>&1
	#case "$?" in
		#0) mode=dark ;;
		#*) mode=light ;;
	#esac
	#echo $mode
	dark-notify --exit
}

# Updates status from macOS to cache, and then return value
st_update_status_from_macos() {
	local mode=$(st_read_macos_mode)
	declare -A opts_g=( [mode]=$mode )
	st_set_statusfile opts_g
}


st_set_all() {
	local opts_var_name=$1
	st_set_statusfile $opts_var_name
	st_set_iterm2 $opts_var_name
	st_set_tmux $opts_var_name
	st_set_xrdb $opts_var_name
	st_set_macos $opts_var_name
}
