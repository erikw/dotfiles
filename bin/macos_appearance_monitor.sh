#!/usr/bin/env bash
# Monitor changes to Dark/Light apparance mode in macOS.
# Heavily inspired by https://gist.github.com/jerblack/869a303d1a604171bf8f00bbbefa59c2 but implemented in shell.
# Dependencies: $ brew install fswatch dark-notify
#
# fswatch tutorial: http://emcrisostomo.github.io/fswatch/doc/1.14.0/fswatch.html/Tutorial-Introduction-to-fswatch.html#Tutorial-Introduction-to-fswatch
# Install with launchagent, see macos_install.sh

source $HOME/bin/solarized_toggle_lib.sh
declare -A opts_g=( [mode]=unset [macos_update]=false)

# Plist version
#plist=$HOME/Library/Preferences/.GlobalPreferences.plist
#fswatch --one-per-batch --event Renamed $plist | while read change; do \
	#mode=$(st_read_macos_mode)
	#echo "macOS appearace set to $mode"

	##$HOME/bin/solarized_toggle.sh -m $mode
	#mode_old=$(st_read_status)
	#if [ $mode_old != $mode ]; then
		#printf "Toggling from %s->%s\n" $mode_old $mode
		#opts_g[mode]=$mode
		#st_set_all opts_g
	#fi

#done

# dark-notify version. More reliabe.
while read mode; do
	echo "macOS appearace set to $mode"

	#$HOME/bin/solarized_toggle.sh -m $mode
	mode_old=$(st_read_status)
	if [ "$mode_old" != "$mode" ]; then
		printf "Toggling from %s->%s\n" $mode_old $mode
		opts_g[mode]=$mode
		st_set_all opts_g
	fi
done < <(dark-notify)
