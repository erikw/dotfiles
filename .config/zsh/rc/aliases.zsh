# RC: Aliases
# Suppress alias expansion:: $ \aliasname || 'aliasname'
# Print alias definition: alias <aliasname>
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# Documentation {{
# PURPOSE
#   Defines a comprehensive set of **interactive aliases and command wrappers**
#   to improve CLI ergonomics, defaults, and workflows across environments.
#
#   This file centralizes all alias logic, including OS-specific behavior,
#   tool enhancements, and productivity shortcuts.
#
# RESPONSIBILITIES
#   ✔ Desktop/OS-specific command behavior
#     - open, logout, screensaver, trash handling
#     - Conditional logic via $DESKTYPE and platform checks
#
#   ✔ CLI UX improvements
#     - Enable colors (ls, grep, gcc diagnostics)
#     - Improve defaults for common tools
#
#   ✔ Tool substitution and enhancement
#     - Prefer modern tools if available (lsd, colordiff, cdu)
#     - Normalize behavior across systems (BSD vs GNU)
#
#   ✔ Program-specific aliases
#     - vim/nvim behavior
#     - libreoffice commands
#     - gpg, pdflatex, octave, etc.
#
#   ✔ Workflow and productivity shortcuts
#     - File/system utilities (ll, dusch, mkdirtoday, etc.)
#     - Git helpers, systemctl shortcuts, process helpers
#     - fzf-marks integration and bookmark helpers
#
#   ✔ XDG compatibility wrappers
#     - Force tools to respect XDG config locations
#
#   ✔ SSH and system helpers
#     - ssh-agent helpers (keyon/off/list)
#     - sudo command wrappers
#
#   ✘ DO NOT put here:
#     - Environment variables (→ env/*)
#     - PATH modifications (→ env/programs.zsh)
#     - Tool initialization or sourcing (→ rc/tools.zsh)
#     - Large or slow logic unrelated to command usage
#
# WHY
#   This file:
#     - standardizes command behavior across machines
#     - reduces friction in daily terminal usage
#     - adapts dynamically to available tools and OS differences
#
#   It acts as a **UX layer** on top of the raw shell environment.
#
# STARTUP CONTEXT
#   Loaded during:
#     → .zshrc (interactive shells only)
#
#   So it affects:
#     - terminal sessions
#     - NOT scripts or non-interactive shells
#
# RULE OF THUMB
#   "Does this change how I type or use commands interactively?"
#     → YES → put it here
#
#   "Does this configure environment or initialize a tool?"
#     → NO → belongs in env/* or rc/tools.zsh
# }}

# Desktop Environment specific {{
case $DESKTYPE in
	kde)
		alias open='kde-open'
		# Log out
		alias xlogout='qdbus org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.logout 0 0 2'
		alias afk='qdbus org.kde.screensaver /ScreenSaver org.freedesktop.ScreenSaver.SetActive true > /dev/null'
		# Empty KDE trash folders.
		alias emptytrash='rm -rf ~/.local/share/Trash/info/* ~/.local/share/Trash/files/*'
		;;
	gnome)
		alias open='gnome-open'
		alias xlogout='gnome-session-save --force-logout'
		;;
	mate)
		alias open='mate-open'
		alias xlogout='mate-session-save --force-logout'
		;;
	openbox)
		alias open='thunar'
		alias xlogout='openbox-logout'
		;;
	dwm)
		alias open='xdg-open'						# Open files.
		alias afk='xscreensaver-command -lock'		# Start screensaver.
		alias xlogout='pkill -f startdwm.sh'
		alias afk='slimlock'
		;;
	macos)
		alias afk='/System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine'

	# Show or hide dotfiles in Finder.app.
	alias mac_showhidden='defaults write com.apple.finder AppleShowAllFiles TRUE; killall Finder'
	alias mac_hidehidden='defaults write com.apple.finder AppleShowAllFiles FALSE; killall Finder'

	alias mac_emptytrash='rm -rf ~/.Trash/*'		# Empty trash bin.
	alias mac_app_store_apps="find /Applications \-maxdepth 4 \-path '*Contents/_MASReceipt/receipt' -print |\sed 's#.app/Contents/_MASReceipt/receipt#.app#g; s#/Applications/##'"		# List apps installed from App Store.
	;;
*)
	alias open='xdg-open'						# Open files.
	alias afk='xscreensaver-command -lock'		# Start screensaver.
	;;
esac
# }}

# Color support {{
if has_command lsd; then
	alias ls=lsd
else
	LS_OPTIONS=()

	shell_is_linux && LS_OPTIONS+=(--time-style=long-iso -F)

	# List with colors when output is terminal.
	LS_OPTIONS+=(--color=auto)

	if shell_is_macos && has_command gls; then
		# Still need to set alias with options, https://superuser.com/a/670563/42070.
		# Note that for coreutil ls to have color output, dircolors must be evalued.
		alias ls="gls ${LS_OPTIONS[*]}"
	else
		alias ls="ls ${LS_OPTIONS[*]}"
	fi
fi

# Highligt matches when output is on the terminal.
# Note that GREP_OPTIONS is no longer; need to make alias ourselves:
# https://www.gnu.org/software/grep/manual/html_node/Environment-Variables.html
alias grep="grep --color=auto"
# Force color e.g. to use when piping to less.
alias grepc='grep --color=always'

if has_command colordiff ; then
	alias cdiff='colordiff'
fi

# Use colored du if exists.
if has_command cdu ; then
	alias du='cdu -idh'
fi

# Make colors.
#if has_command colormake; then
	#alias make='colormake'
#fi

# Compile with dem colors.
if has_command gcc; then
	alias gcc="gcc -fdiagnostics-color=auto"
fi

# }}

# Coreutils {{
# Hand-picked tools that we use use instead of the basic BSD versions in macOS
# AVOID gfind, ggrep as they can break source compilation builds.
if shell_is_macos && has_command grm; then
	alias rm='grm'	# The BSD version can't append arguments after filenames.
fi
#
# }}

# SSH agent {{
alias keyon="ssh-add -t 14400"
alias keyoff='ssh-add -D'
alias keylist='ssh-add -l'
# }}

# XDG {{
alias bashdb='bashdb -x ${XDG_CONFIG_HOME:-$HOME/.config}/bashdb/bashdbinit'
alias svn='svn --config-dir ${XDG_CONFIG_HOME:-$HOME/.config}/subversion'
alias yarn='yarn --use-yarnrc $XDG_CONFIG_HOME/yarn/config'
#alias irssi='irssi --config="$XDG_CONFIG_HOME"/irssi/config --home="$XDG_DATA_HOME"/irssi'
# }}

# Sudo {{
# Prefix these sudo aliases with '\' so that e.g. the freebsd sudo alias is not used here, as sudoers POWER group command does not work then.
for cmd in poweroff halt shutdown reboot; do
	alias $cmd="\sudo $cmd"
done
# }}

# cd-bookmark {{
# Bashmark-style aliases
#if [ -e $XDG_CONFIG_HOME/cd-bookmark/bookmarks ]; then
	#alias g='cd-bookmark -c'
	#alias s='cd-bookmark -a'
	#alias l='cd-bookmark -l'
	#alias e='cd-bookmark -e'
	#alias p='cd-bookmark -p'
	#alias d='cd-bookmark -d'
#fi
# }}

# fzf-marks {{
# Bashmark style aliases
if [ -d $HOME/.local/repos/fzf-marks ]; then
	alias g='fzm'
	alias s='mark'
	alias e="vi $FZF_MARKS_FILE"
	alias l="sort $FZF_MARKS_FILE"
	alias d='fzf_marks_delete' # My custom zsh function.
	alias p='fzf_marks_print' # My custom zsh function.
fi
# }}

# Libreoffice {{
if has_command libreoffice; then
	for app in base calc draw impress math writer; do
		alias l$app="libreoffice --$app"
	done
fi
# }}

# Vim {{
if has_command nvim; then
	alias vi='nvim'
	alias view='nvim -R'
	alias nview='nvim -R'
	alias nvimdiff='nvim -d'
	alias nvimplain="vim -u NONE -i NONE"
	alias nvim_clean='rm -rf ${XDG_DATA_HOME:-$HOME/.local/share}/nvim/{.netrwhist,shada,swap,undo,view}/ ${XDG_CACHE_HOME:-$HOME/.cache}/nvim/'		# It's a new-start!
	alias vis='nvim -c OpenSession'  # Load ticket.vim session on start.
elif has_command vim; then
	alias vi='vim'						# Be IMproved.
	alias view='vim -R'					# Not all distributions of Vim provide the readonly bin.
	alias viplain="vim -u NONE -i NONE"				# Start wiht without reading ~/.vimrc and using ~/.viminfo.
	alias vim_clean='rm -rf ~/.vim/{.netrwhist,fuf-data,swap,view,viminfo,yankring_v2.txt} ~/.vim/undo/* ~/.cache/vim/swap/'		# It's a new-start!
fi
# }}

# Program enhancements {{
alias emacs='emacs --no-window-system'		# Emacs belongs to the terminal.
alias gdb='gdb -q'							# Suppress legal info.
alias cgdb='cgdb -q'						# Suppress legal info.

alias dfc='dfc -d'							# Show used column.
alias octave='octave-cli --silent'			# Run in terminal without greeting message.
alias xoctave='\octave'						# Default X version.
#alias matlab='matlab -nodesktop -nosplash'	# Run in terminal with no splash screen.
#alias xmatlab='\matlab'					# Default X version.
alias gimp='gimp --no-splash'				# Splash screens are just annoying.
#alias dmenu="dmenu -i"						# Ignore case.
alias gpg='gpg --list-options no-show-photos'	# Don't open profile photos on listings - super annoying!
alias grip='grip --browser'						# Open new tab in browser, until this can be configured: https://github.com/joeyespo/grip/issues/340
alias pdflatex='pdflatex -interaction=nonstopmode -halt-on-error' # Quit on error.

#has_command batman && alias man='batman'			# Using bat from bat-extras package.
# }}

# Short-hands {{
alias ll='ls -l'										# I don't use it but aliens on my systems presumes its existence.
alias vboxmanage='VBoxManage'							# Who likes caps?- I don't.
alias shredzr='shred --zero --remove'					# Zero out and delete file.
alias pkillf="pkill -9 -f"								# Force kill full name matched process.
alias iperl="perl -de 0"								# Interactive perl.
alias catu="cat -vet"									# A cat that likes unprintable characters.
alias tiga='tig --all'									# Show all branches in tig.
alias mkcscope_c='find . -name "*.[ch]" > cscope.files'		# Gen cscope file for C programs.
alias reload_zsh='source $HOME/.zshrc'					# Reload zsh configuration.
alias reload_bash='source $HOME/.bashrc'				# Reload bash configuration.
alias remove_swap_files='find . -name "*.sw[op]" -delete'	# Delete all swap files in current path recursively.
alias dusch='du -sch'									# The best file size calculator is a shower.
alias beep='echo -en "\007"'							# Whoop whoop'
alias image_dim="identify -format '%w %h\n'"			# Get dimmensions of an image.
alias cursh="ps -p \$\$ | tail -1 | awk '{print \$NF}' | sed -e 's/^-//g'| tr -d '()'"		# Current shell.
alias history-off='unset HISTFILE'				# Disable command history for the current shell.
alias whatismyip='curl ifconfig.me && echo'		# Get external IP-address
#alias whatismyip='curl ifconfig.co'			# Get external IP-address
alias path_print='echo $PATH | tr : \\n'			# Easier to read $PATH.
#alias goaccess_nginx='goaccess --log-format=COMBINED -m /var/log/nginx/access.log'	# Get web server stats based on log file.
#alias goaccess_uberspace='uberspace_collect_access_log.sh && goaccess -m --agent-list --ignore-crawlers --config-file ~/etc/goaccess.conf --log-format=COMBINED --log-file ~/logs/www_access_log_all'
#alias restic_env_b2='source $HOMEBREW_PREFIX/etc/restic/default.env.sh'		# Init restic env for B2.

#alias find_dropbox_conflicts='find ~/dropbox/doc -name "*conflicted copy*"'	# Find conflicting synced dropbox files.
alias find_large_files="find . -type f -size +5M -print0 | xargs -0 ls -lh | sort -k5,5 -h | awk '{print \$5, \$9}'"	# Find large files.
alias find_large_pdfs="find . -name \"*.pdf\" -type f -size +5M -print0 | xargs -0 ls -lh | sort -k5,5 -h | awk '{print \$5, \$9}'"	# Find large PDFs.

#alias git-root='cd $(git rev-parse --show-cdup)'		# Go to the root of a git. See overlay shell function as well.
alias git_top_contribs='git log | grep Author | sort | uniq -c | sort -n -r'	# Show top authors of a git repo.
alias ghq-get='ghq get --look'							# Fetch and cd to repository.
alias clone=ghq-get

if shell_is_linux; then
	alias sysc='systemctl'									# The length of a name should correspond to its importance, see vi.
	alias syscu='systemctl --user'							# Systemd user sessions.
	alias journal='journalctl'
elif shell_is_macos; then
	alias brew_outdated='brew outdated -v | grep -v "\[pinned at .*\]" || :'		# Outdated brew packages.
	alias intellijopen='open -a IntelliJ\ IDEA\ CE'	# Open Intellij with a path as an argument.
	alias pycharmopen='open -a PyCharm\ CE'		# Open Pycharm with a path as an argument.
	alias phpstormopen='open -a PhpStorm'		# Open PhpStorm with a path as an argument.
	alias pixelmator='open -a Pixelmator\ Pro'	# Open Pixelmator with a path as an argument.
fi

# Testing
#alias t="bin/rails test"

#alias x-proxy='ssh x -L 8080:x.com:123 -N'				# Start SSH tunnel web proxy to some server.
#alias chromium-xproxy='chromium --proxy-server="http://localhost:8080"'	# Starts Chromium that uses X proxy tunnel.


# Debian rename's some commands.
if type ack-grep >/dev/null 2>&1; then
	alias ack='ack-grep'
fi
if type fdfind >/dev/null 2>&1; then
	alias fd='fdfind'
fi
# }}


# Permutation aliases {{
# From $(bin/permute_aliases.sh cmd > $ZDOTDIR/rc/aliases_cmd.zsh)
#sourceifexists $ZDOTDIR/rc/aliases_make.zsh
#sourceifexists $ZDOTDIR/rc/aliases_git.zsh
# }}

# Copy & Paste {{
# Linux version of macOS pbcopy and pbpaste.
# Ref: https://medium.com/@codenameyau/how-to-copy-and-paste-in-terminal-c88098b5840d
if shell_is_linux; then
	alias pbcopy='xsel --clipboard --input'
	alias pbpaste='xsel --clipboard --output'

	#alias pbcopy='xclip -selection clipboard'
	#alias pbpaste='xclip -selection clipboard -o'
fi
# }}
