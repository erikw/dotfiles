# RC: Bindings
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# Bindings {{
	# Must happen before setting up fzf. Ref: https://github.com/junegunn/fzf/issues/1596#issuecomment-2128091715
	bindkey -v	# vi command editing mode. NOTE: zsh is not using readline('s .inputrc').

	# View binding namespaces with $(bindkey -l). Then view bindkings for a ns with $(bindkey -m <ns>)
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
	# Visual mode in vi-mode, like in bash.
	autoload -U edit-command-line
	zle -N edit-command-line
	bindkey -M vicmd v edit-command-line
# }}
