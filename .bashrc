# Erik Westrup's bashrc.
# NOTE Login shells read ~/.profile, normal and interactive shells read ~/.bashrc.

# Modeline {
#	vi: foldmarker={,} filetype=sh foldmethod=marker foldlevel=0: tabstop=4 shiftwidth=4:
# }

# Source global profile.
# NOTE resets PATH
if [ -f /etc/profile ] && [ -r /etc/profile ]; then
	source /etc/profile
fi


if [ -f $HOME/.shell_commons ] && [ -r $HOME/.shell_commons ]; then
	my_shell=bash
	export completion_func=complete
	source $HOME/.shell_commons
fi

# Set Vi command line editing mode. Not needed because it's set in ~/.inputrc.
#set -o vi

# Completion {
	# Complete @hostnames in a file with /ets/hosts format.
	HOSTFILE=/etc/hosts

	# Enable bash tab completion. Not needed with package 'bash-completion' installed.
	#complete -cf sudo
	#complete -cf man
# }

# History {
	# Number lines to store in active bash session.
	export HISTSIZE=100000
	# Number lines to store in history file after session end.
	export HISTFILESIZE=100000
	# Don't put duplicate commands in the history.
	export HISTCONTROL="erasedups:ignoreboth"
	# Commands to ignore in history.
	export HISTIGNORE="&:[ ]*:exit:halt:poweroff:shutdown:reboot:xlogout:pm-hibernate:pm-suspend"
	# Append instead of overwrite history on exit.
	shopt -s histappend
	# Allow multiline commands as one command.
	shopt -s cmdhist
# }

# UI {
	# Source PS1 configuration.
	sourceifexists "$HOME/.bash_ps1"

	# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
	shopt -s checkwinsize

	# Colored man pages.
	# Reference: https://wiki.archlinux.org/index.php/Man_Page#Colored_man_pages
	man() {
		env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
			man "$@"
	}
# }

# Programs {
	# Sorce bashmarks.
	#sourceifexists $HOME/.local/bin/bashmarks.sh

	# Jump shell bookmarks.
	# NOTE moved to ~/.sandboxrc
	#if type jump-bin >/dev/null 2>&1; then
		#source $(jump-bin --bash-integration)/shell_driver
		## Bashmark style aliases
		#alias g="jump"
		#alias s="jump --add"
		#alias d="jump --del"
		#alias l="jump --list"
	#fi

	# Gitignore boiler plate.
	if [ -d $HOME/src/github.com/simonwhitaker/gibo ]; then
		PATH="$HOME/src/github.com/simonwhitaker/gibo:$PATH"
		source $HOME/src/github.com/simonwhitaker/gibo/gibo-completion.bash
	fi
# }

# Powerline {
	if [ -d $POWERLINE_ROOT ]; then
		POWERLINE_BASH_CONTINUATION=1
		POWERLINE_BASH_SELECT=1
		source $POWERLINE_ROOT/bindings/bash/powerline.sh
	fi
# }

sourceifexists $HOME/.shell_startx
