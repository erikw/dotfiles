# Erik Westrup's zshrc.

# Modeline {
#	vi: foldmarker={,} filetype=zsh foldmethod=marker foldlevel=0: tabstop=4 shiftwidth=4:
# }

#PROFILE_STARTUP=true
# Source: https://kev.inburke.com/kevin/profiling-zsh-startup-time/
#if [[ "$PROFILE_STARTUP" == true ]]; then
    ## http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    #PS4=$'%D{%M%S%.} %N:%i> '
    #exec 3>&2 2>$HOME/tmp/startlog.$$
    #setopt xtrace prompt_subst
#fi

# Common shell settings.
if [[ -f $HOME/.shell_commons && -r $HOME/.shell_commons ]]; then
	export my_shell=zsh
	export completion_func=compctl
	source $HOME/.shell_commons
fi

# Environment {
	typeset -U path		# Don't add entry to path if it's already present.
	#path=(~/tmp $path)

	# Function paths.
	# - .zsh_funcs - custom functions
	# - .zprompts - custom prompt themes
	fpath=(~/.zsh_funcs $fpath)

	# Extra zsh completions not in core zsh: https://github.com/zsh-users/zsh-completions
	if [ -d /usr/local/share/zsh-completions ]; then
		fpath=(/usr/local/share/zsh-completions $fpath)
	fi
# }

# Completion {
	zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
	zstyle ':completion:*' max-errors 3 numeric
	# Visualize and selecting with arrow keys in completion.
	zstyle ':completion:*' menu select
	# Remove slash from completed directory.
	zstyle ':completion:*' squeeze-slashes true
	# Cache completions.
	zstyle ':completion:*' use-cache onzstyle ':completion:*' use-cache on
	# Honor LS_COLORs in completion.
	zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
	# Ignore case in tab complete. http://www.rlazo.org/2010/11/18/zsh-case-insensitive-completion/
	zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
	# Completing process IDs with menu selection:
	zstyle ':completion:*:*:kill:*' menu yes select
	zstyle ':completion:*:kill:*' force-list always
	# Style if no matching completion is found.
	zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
	# Refresh tab completion from PATH automatically, so hash(1) does not need to be called after installing a new program.
	zstyle ':completion:*' rehash true

	# Turn off URL completions for the open command, like "file: ftp:// gopher:// http:// https://"
	# Reference: https://github.com/mpv-player/mpv/issues/2892
	zstyle ':completion:*:*:open:*' tag-order '!urls'

	# Use colors in tabcompletion
	shell_is_macos && zstyle ':completion:*:default' list-colors ''

	# Complete options for aliases too.
	setopt completealiases
	# List files when cd-completing.
	#compdef _path_files cd

	autoload -Uz compinit
	compinit -C
# }

# History {
	export HISTFILE=~/.zsh_histfile		# Where to save history.
	export HISTSIZE=1000000				# How many lines in the current session to remember.
	export SAVEHIST=1000000				# How many lines to save to disk. Must be <=HISTSIZE.
	# Patterns to exclue. Separate with |. *-matching.
	export HISTORY_IGNORE="poweroff|reboot|halt|shutdown|xlogout"

	setopt appendhistory		# Append to history write on exit, don't overwrite.
	setopt histignoredups		# Don't save immediate duplicates lines in history.
	setopt histignorespace		# Ignore commands starting with space.
	setopt extendedhistory		# Save command time start and exec time in seconds.
	setopt histreduceblanks		# Strip redundant spaces.
# }

# UI {
	autoload -U colors && colors

	# Prompt settings.
	#if [ -n "$POWERLINE_ROOT" ] && [ -d $POWERLINE_ROOT ]; then
		#source $POWERLINE_ROOT/bindings/zsh/powerline.zsh
	#else
		#autoload -Uz promptinit
		#promptinit
		#prompt suse	# Prompt theme.
	#fi
	autoload -Uz promptinit
	promptinit

	# Prompt theme. Explore with $(prompt -l)
	#prompt suse
	#prompt erikw

	# Set prompt with git branch.
	# Modified version of https://stackoverflow.com/a/12935606/265508
	setopt prompt_subst
	autoload -Uz vcs_info
	zstyle ':vcs_info:*' formats '%F{5}[%F{2}%b%F{5}] %F{2}%c%F{3}%u%f'
	zstyle ':vcs_info:*' enable git cvs svn
	precmd () { vcs_info }
	#PROMPT='%* %F{5}[%F{2}%n@%m%F{5}] %F{3}%3~ ${vcs_info_msg_0_}%{$reset_color%}> '
	# Less colorful version. Looks more like ~/.bash_ps1
	PROMPT='%D{%H:%M:%S} %n@%m %F{3}%3~ ${vcs_info_msg_0_}%{$reset_color%}> '


	# Fish like syntax highlighting on command line.
	zsh_syntax_path=
	if shell_is_linux; then
		zsh_syntax_path=/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	elif shell_is_bsd; then
		zsh_syntax_path=/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	fi
	if [ -n "$zsh_syntax_path" ] && [ -f $zsh_syntax_path ]; then
		source $zsh_syntax_path
	fi
# }

# Options {
	# Manual & categories: http://zsh.sourceforge.net/Doc/Release/Options.html

	# Changing Directories {
		setopt autopushd				# Add prev PWD to directory stack.
		setopt pushdignoredups			# No duplicates in dirs stack.
		setopt pushdignoredups			# Do not record immediate duplicates.
		setopt pushdtohome				# pushd with no args pushes $HOME.
		setopt interactivecomments		# Enable bash-like comments by prefixing a command with '#' to make it a comment.
		#setopt chaselinks		# Go to full destination of symlinks.
	# }

	# Input/Output {
		unsetopt correct correctall 	# Do not encourage sloppy typing.
		#setopt nohashdirs		# No need for rehash to find new binaries.
		#setopt printexitvalue 		# Print abnormal exit status.
	# }

	# Job Control {
		setopt longlistjobs		# Display PID when suspending processes.
	# }

	# Shell Emulation # {
		#setopt ksharrays		# Array are 0-indexed. NOTE breaks zsh functions, plugins, etc...
		setopt shnullcmd		# Truncate like in bash e.g. $(>file).
	# }

	# ZLE {
		setopt nobeep			# No beeps thanks!
	#}
# }

# Bindings {
	# View binding namespaces with $(bindkey -l). Then view bindkings for a ns with $(bindkey -m <ns>)
	bindkey -v								# vi command editing mode.
	export KEYTIMEOUT=1						# Set ESC to normal mode timout to 10 ms. Default is 40ms.
	bindkey '^[[Z' reverse-menu-complete	# Reverse select on shift tab in completion menu.
	bindkey "\ep" insert-last-word			# Insert !$ with Alt-p.
	bindkey ' ' magic-space					# Expand !-commands on space.
	bindkey "^R" history-beginning-search-backward # Complete from history with prefix
	bindkey "^E" history-beginning-search-forward # Complete from history with prefix

	# Enable char deleteion on command from history.
	bindkey "^?" backward-delete-char
	bindkey "^H" backward-delete-char
	bindkey "^W" backward-kill-word
	bindkey "^U" backward-kill-line

	# Make delete key work in macOS. Must be after "bindkey -v" to work!
	# Source: https://stackoverflow.com/questions/33270381/delete-forward-character-iterm2-osx
	# Source: https://superuser.com/questions/288684/terminal-on-mac-delete-key-behavior
	if shell_is_macos; then
		bindkey "^[[3~"  delete-char
		bindkey "^[3;5~" delete-char
	fi
# }

# ZLE {
	# Let / search in vi mode. Defined in ~/.zsh_funcs/vi-search-fix
	# Reference: http://superuser.com/questions/476532/how-can-i-make-zshs-vi-mode-behave-more-like-bashs-vi-mode
	autoload vi-search-fix
	zle -N vi-search-fix
	bindkey -M viins '\e/' vi-search-fix

	# Visual mode in vi-mode, like in bash.
	autoload -U edit-command-line
	zle -N edit-command-line
	bindkey -M vicmd v edit-command-line
# }

# zsh extras {
	# Enable help command for zsh functions.
	autoload -U run-help
	autoload run-help-git run-help-svn run-help-svk
	#unalias run-help
	alias help=run-help
# }

# Programs {
	# Shell bookmarks with jump. https://github.com/flavio/jump

	# Jump shell bookmarks.
	# NOTE moved to ~/.sandboxrc
	#if type jump-bin >/dev/null 2>&1; then
		#source $(jump-bin --zsh-integration)
		## Bashmark style aliases
		#alias g="jump"
		#alias s="jump --add"
		#alias d="jump --del"
		#alias l="jump --list"

		# Add completion to 'g' alias.
		#compctl -K _jump -S '' g
	#fi

	# Gitignore boiler plate.
	if [ -d $HOME/src/github.com/simonwhitaker/gibo ]; then
		PATH="$HOME/src/github.com/simonwhitaker/gibo:$PATH"
		#source $HOME/src/github.com/simonwhitaker/gibo/gibo-completion.zsh
	fi
# }

sourceifexists $HOME/.shell_startx

#if [[ "$PROFILE_STARTUP" == true ]]; then
    #unsetopt xtrace
    #exec 2>&3 3>&-
#fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
#export PATH="$PATH:$HOME/.rvm/bin"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
