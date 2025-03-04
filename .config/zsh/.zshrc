# Erik Westrup's zshrc.
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4
# }}

# After running this, inspect result of current shell with:
# $ ~/bin/parse_zsh_startup.py ~/tmp/startuplog.$$
# Source: https://kev.inburke.com/kevin/profiling-zsh-startup-time/
#PROFILE_STARTUP=true
#if [ "$PROFILE_STARTUP" = true ]; then
#    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
#    PS4=$'%D{%M%S%.} %N:%i> '
#    exec 3>&2 2>$HOME/tmp/startlog.$$
#    setopt xtrace prompt_subst
#fi

# Common shell settings.
if [ -f ${XDG_CONFIG_HOME:-$HOME/.config}/shell/commons ]; then
	export SHELL_NAME=zsh
	export completion_func=compctl
	source ${XDG_CONFIG_HOME:-$HOME/.config}/shell/commons
fi

# Environment {{
	typeset -U path		# Don't add entry to path if it's already present.

	# Function paths.
	# - .zsh_funcs/ - custom functions e.g. completion functions installed here.
	# - .zprompts/ - custom prompt themes
	fpath+=$XDG_CONFIG_HOME/zsh/.zsh_funcs/
	# Homebrew zsh completions. Reference: https://docs.brew.sh/Shell-Completion
	# Some of the completion functions comes from https://github.com/zsh-users/zsh-completions
	if [ -d $HOMEBREW_PREFIX/share/zsh-completions ]; then
		fpath+=$HOMEBREW_PREFIX/share/zsh-completions
	fi
	# Global functions which could also be completion functions.
	if [ -d $HOMEBREW_PREFIX/share/zsh/site-functions ]; then
		fpath+=$HOMEBREW_PREFIX/share/zsh/site-functions
	fi
# }}

# Completion {{
	zstyle ':completion:*' menu select	# Visualize and selecting with arrow keys in completion.
	# Completion functions to try in given order. Ref: https://zsh.sourceforge.io/Doc/Release/Completion-System.html
	zstyle ':completion:*' completer _expand _expand_alias _extensions _complete _ignored _correct _approximate
	# Workaround for https://github.com/mollifier/cd-bookmark/issues/9
	#zstyle ':completion:*:*:cd-bookmark:*' menu no

	# Completion functions settings.
	# _correct max errors for match (but not for numbers)
	zstyle ':completion:*:correct:::' max-errors 2 not-numeric
	# _approximate max errors for match
	zstyle ':completion:*:approximate:::' max-errors 3 numeric
	# Remove slash from completed directory.
	zstyle ':completion:*' squeeze-slashes true
	# Cache completions.
	zstyle ':completion:*' use-cache onzstyle ':completion:*' use-cache on
	# Use cache from XDG location
	zstyle ':completion:*' cache-path ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache
	# Honor LS_COLORs in completion. Ref: https://github.com/ohmyzsh/ohmyzsh/issues/6060#issuecomment-1016734641
	zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
	# Ignore case in tab complete. http://www.rlazo.org/2010/11/18/zsh-case-insensitive-completion/
	zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
	# Completing process IDs with menu selection:
	zstyle ':completion:*:*:kill:*' menu yes select
	zstyle ':completion:*:kill:*' force-list always
	# Style if no matching completion is found.
	zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
	# Refresh tab completion from PATH automatically, so hash(1) does not need to be called after installing a new program.
	zstyle ':completion:*' rehash true

	# Turn off URL completions for the open(1) command, like "file: ftp:// gopher:// http:// https://"
	# Ref: https://github.com/mpv-player/mpv/issues/2892#issuecomment-190910887
	# Ref: https://unix.stackexchange.com/a/567805/19909
	zstyle ':completion:*:*:open:*' tag-order '!urls'
	#zstyle ':completion:*:open:argument*' tag-order - '! urls'

	# Use colors in tabcompletion. NOTE seems to work without this.
	#shell_is_macos && zstyle ':completion:*:default' list-colors ''

	# Increase maximum from default 100 suggestions to complete before asking to show more.
	export LISTMAX=500

	# Complete options for aliases too.
	# NOPE setting this means that aliases are not expanded before completion. I don't want this as then
	# $ g <tab>
	# does not work (g alias for 'cd-bookmark -c')
	setopt completealiases

	compinit_regen() {
		rm -f ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION
		compinit -d ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION -i
	}

	autoload -Uz compinit
	# -C: [shell startup time optimization] ignore checking for new comp files. The dump file will be
	#       created if there isn’t one already. NOTE Thus, for new files e.g. added to fpath, manually
	#       run once the compinit_regen function above.
	# -i: ignore insecure folder/file check, thus include e.g. /usr/local/share/zsh/site-functions
	# -d: Use a specific path to the dumpfile.
	# Reference: http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Initialization
	#compinit -C
	test -d ${XDG_CACHE_HOME:-$HOME/.cache}/zsh || mkdir -p ${XDG_CACHE_HOME:-$HOME/.cache}/zsh
	compinit -d ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION -C
# }}

# History {{
	test -d ${XDG_STATE_HOME:-$HOME/.local/state}/zsh || mkdir -p ${XDG_STATE_HOME:-$HOME/.local/state}/zsh
	export HISTFILE=${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history
	export HISTSIZE=1000000				# How many lines in the current session to remember.
	export SAVEHIST=1000000				# How many lines to save to disk. Must be <=HISTSIZE.
	# Patterns to exclue. Separate with |. *-matching.
	export HISTORY_IGNORE="poweroff|reboot|halt|shutdown|xlogout"

	setopt appendhistory		# Append to history write on exit, don't overwrite.
	setopt histignoredups		# Don't save immediate duplicates lines in history.
	setopt histignorespace		# Ignore commands starting with space.
	setopt extendedhistory		# Save command time start and exec time in seconds.
	setopt histreduceblanks		# Strip redundant spaces.

	# Don't save failed commands (mostly misspellings) to history, to avoid getting them on completion later.
	# Ref: https://superuser.com/a/902508/42070
	zshaddhistory() {
		local j=1
		while ([[ ${${(z)1}[$j]} == *=* ]]) {
			((j++))
		}
		whence ${${(z)1}[$j]} >| /dev/null || return 1
	}
# }}

# UI {{
	autoload -U colors && colors

	# Prompt settings.
	autoload -Uz promptinit
	promptinit

	# Prompt theme. Explore with $(prompt -l)
	#prompt suse
	#prompt erikw # See ~/.config/zsh/.zprompts/prompt_erikw_setup

	# Set prompt with git branch.
	# Modified version of https://stackoverflow.com/a/12935606/265508
	setopt prompt_subst
	autoload -Uz vcs_info
	zstyle ':vcs_info:*' formats '%F{5}[%F{2}%b%F{5}]%F{2}%c%F{3}%u%f'
	zstyle ':vcs_info:*' enable git cvs svn
	precmd () { vcs_info }
	# See formatting options in manpage zshmisc(1) under the section SIMPLE PROMPT ESCAPES.
	# Mimics the look of my $XDG_CONFIG_HOME/bash/ps1
	# NOTE virtualenvwrapper prepends the active venv name in the generated bin/activate script.
	PROMPT="%D{%H:%M:%S}"								# Date with seconds
	[ $(id -u) -eq 0 ] && user_color=red || user_color=blue
	if [ "$CODESPACES" != true ]; then
		PROMPT="$PROMPT %F{$user_color}%n%{$reset_color%}@%F{cyan}%m%{$reset_color%}"	# Current user and hostname.
	fi
	unset user_color
	if [ -n "$SSH_CLIENT" ] && ! ([ -n "$TMUX" ] || [[ "$TERM" == "screen-"* ]] ); then
		# Highlight when logged in via SSH. But not in screen/tmux, that does not make sense.
		PROMPT="$PROMPT %F{blue}[SSH]%{$reset_color%}"
	fi
	if [ "$CODESPACES" = true ]; then
		trunc_len=2
	else
		trunc_len=5
	fi
	PROMPT="$PROMPT %F{3}%${trunc_len}~%{$reset_color%}"			# CWD, truncated to $trunc_len components (directory depth).
	unset trunc_len
	PROMPT="$PROMPT \${vcs_info_msg_0_}"				# Current VCS branch, as configured above. $ is escaped so this part is not evaluated yet (breaks then).
	PROMPT="$PROMPT%1(j:[%j]:)"							# Number of background jobs (if >=1).
	PROMPT="$PROMPT%(?::%F{red}{%?}%{$reset_color%})"	# Last exit code if !=0
	PROMPT="$PROMPT> "									# EOL


	# Fish like syntax highlighting on command line.
	zsh_syntax_path=
	if shell_is_macos; then
		zsh_syntax_path=$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	elif shell_is_linux; then
		zsh_syntax_path=/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	elif shell_is_bsd; then
		zsh_syntax_path=/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	fi
	if [ -n "$zsh_syntax_path" ] && [ -f "$zsh_syntax_path" ]; then
		source $zsh_syntax_path
	fi
	unset zsh_syntax_path
# }}

# Options {{
	# Manual & categories: http://zsh.sourceforge.net/Doc/Release/Options.html
	setopt nobeep			# No beeps thanks!

	# Changing Directories
	setopt autopushd				# Add prev PWD to directory stack.
	setopt pushdignoredups			# No duplicates in dirs stack.
	setopt pushdtohome				# pushd with no args pushes $HOME.
	setopt interactivecomments		# Enable bash-like comments by prefixing a command with '#' to make it a comment.

	# Input/Output
	unsetopt correct correctall		# Do not encourage sloppy typing.
	#setopt nohashdirs				# No need for rehash to find new binaries.
	#setopt printexitvalue			# Print abnormal exit status.

	# Job Control
	setopt longlistjobs		# Display PID when suspending processes.

	# Shell Emulation
	setopt shnullcmd		# Truncate like in bash e.g. $(>file).
# }}

# Bindings {{
	# View binding namespaces with $(bindkey -l). Then view bindkings for a ns with $(bindkey -m <ns>)
	bindkey -v								# vi command editing mode.
	export KEYTIMEOUT=1						# Set ESC to normal mode timout to 10 ms. Default is 40ms.
	bindkey '^[[Z' reverse-menu-complete	# Reverse select on shift tab in completion menu.
	bindkey "\ep" insert-last-word			# Insert !$ with Alt-p.
	bindkey ' ' magic-space					# Expand !-commands on space.

	# fzf provies a better ^R search.
	if ! program_is_in_path fzf; then
		bindkey "^R" history-beginning-search-backward	# Complete from history with prefix
		bindkey "^E" history-beginning-search-forward	# Complete from history with prefix
	fi

	# Enable char deletion on command from history.
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

	# Add text object extension in normal mode -- eg: ci" or da(
	autoload -U select-quoted
	zle -N select-quoted
	for m in visual viopp; do
		for c in {a,i}{\',\",\`}; do
			bindkey -M $m $c select-quoted
		done
	done
# }}

# ZLE {{
	# Let / search in vi mode. Defined in ~/.config/zsh/.zsh_funcs/vi-search-fix
	# Reference: http://superuser.com/questions/476532/how-can-i-make-zshs-vi-mode-behave-more-like-bashs-vi-mode
	autoload vi-search-fix
	zle -N vi-search-fix
	bindkey -M viins '\e/' vi-search-fix

	# Visual mode in vi-mode, like in bash.
	autoload -U edit-command-line
	zle -N edit-command-line
	bindkey -M vicmd v edit-command-line
# }}


# Programs {{
	# cd-bookmark. Aliases in ~/.config/shell/aliases
	#if [ -d ~/.local/repos/cd-bookmark ]; then
	#    #fpath=(~/src/github.com/erikw/cd-bookmark/(N-/) $fpath)
	#    fpath=(~/.local/repos/cd-bookmark(N-/) $fpath)
	#    autoload -Uz cd-bookmark
	#fi

	# fzf-marks: https://github.com/urbainvaes/fzf-marks
	# Done here and not in commons, as it must be after $(bindkeys -v)
	if [ -d $HOME/.local/repos/fzf-marks ]; then
		sourceifexists $HOME/.local/repos/fzf-marks/fzf-marks.plugin.$SHELL_NAME
		# --exact --select-1: jump to exact match directly if only match.
		# --nth=1 --delimiter=' : ': only search the bookmark names, not values.
		FZF_MARKS_COMMAND="$FZF_MARKS_COMMAND --exact --select-1 --nth=1 --delimiter=' : '"

		# Be consistent with default fzf behaviour. ctrl-d should close selection window, not delete things.
		FZF_MARKS_DELETE=ctrl-r
	fi
# }}

#sourceifexists ${XDG_CONFIG_HOME:-$HOME/.config}/X11/startx.sh


# Must be at the end!
#if [ "$PROFILE_STARTUP" = true ]; then
   ##unsetopt xtrace
   ##exec 2>&3 3>&-
#fi
