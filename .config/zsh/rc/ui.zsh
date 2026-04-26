# RC: UI
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# Documentation {{
# PURPOSE
#   Configures terminal UI and visual behavior.
#
# RESPONSIBILITIES
#   ✔ TERM settings
#   ✔ colors (dircolors, LS_COLORS)
#   ✔ terminal capabilities
#
# RULE OF THUMB
#   "Does this affect how the terminal looks?"
#     → YES → belongs here
#
# LOADED FROM
#   .zshrc
# }}

# OMZ/starship migrated {{
#autoload -U colors && colors

## Prompt settings.
#autoload -Uz promptinit
#promptinit

## Prompt theme. Explore with $(prompt -l)
##prompt suse
##prompt erikw # See ~/.config/zsh/.zprompts/prompt_erikw_setup

## Set prompt with git branch.
## Modified version of https://stackoverflow.com/a/12935606/265508
#setopt prompt_subst
#autoload -Uz vcs_info
#zstyle ':vcs_info:*' formats '%F{5}[%F{2}%b%F{5}]%F{2}%c%F{3}%u%f'
#zstyle ':vcs_info:*' enable git cvs svn
#precmd () { vcs_info }
## See formatting options in manpage zshmisc(1) under the section SIMPLE PROMPT ESCAPES.
## Mimics the look of my $XDG_CONFIG_HOME/bash/ps1
## NOTE virtualenvwrapper prepends the active venv name in the generated bin/activate script.
#PROMPT="%D{%H:%M:%S}"								# Date with seconds
#[ $(id -u) -eq 0 ] && user_color=red || user_color=blue
#if [ "$CODESPACES" != true ]; then
#    PROMPT="$PROMPT %F{$user_color}%n%{$reset_color%}@%F{cyan}%m%{$reset_color%}"	# Current user and hostname.
#fi
#unset user_color
#if [ -n "$SSH_CLIENT" ] && ! ([ -n "$TMUX" ] || [[ "$TERM" == "screen-"* ]] ); then
#    # Highlight when logged in via SSH. But not in screen/tmux, that does not make sense.
#    PROMPT="$PROMPT %F{blue}[SSH]%{$reset_color%}"
#fi
#if [ "$CODESPACES" = true ]; then
#    trunc_len=2
#else
#    trunc_len=5
#fi
#PROMPT="$PROMPT %F{3}%${trunc_len}~%{$reset_color%}"	# CWD, truncated to $trunc_len components (directory depth).
#unset trunc_len
#PROMPT="$PROMPT \${vcs_info_msg_0_}"					# Current VCS branch, as configured above. $ is escaped so this part is not evaluated yet (breaks then).
#PROMPT="$PROMPT%1(j:[%j]:)"								# Number of background jobs (if >=1).
#PROMPT="$PROMPT%(?::%F{red}{%?}%{$reset_color%})"		# Last exit code if !=0
#PROMPT="$PROMPT> "										# EOL


## Fish like syntax highlighting on command line.
#zsh_syntax_path=
#if shell_is_macos; then
#    zsh_syntax_path=$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#elif shell_is_linux; then
#    zsh_syntax_path=/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#elif shell_is_bsd; then
#    zsh_syntax_path=/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#fi
#if [ -n "$zsh_syntax_path" ] && [ -f "$zsh_syntax_path" ]; then
#    source $zsh_syntax_path
#fi
#unset zsh_syntax_path
# }}

# Colorize ls(1) on BSD/Mac systems.
shell_is_bsd && export CLICOLOR=1

# Use colorful terminal.
case "$TERM" in
xterm*)		export TERM=xterm-256color ;;
screen*)	export TERM=screen-256color ;;
rxvt*)		export TERM=rxvt-unicode-256color ;;
esac


# Solarized ls colors.
dircolorsdb=$HOME/.local/repos/dircolors-solarized/dircolors.256dark
if ! [ -f "$dircolorsdb" ]; then
	dircolorsdb=$ZDOTDIR/dircolors
fi
# Cache dircolors output to avoid subprocess on every interactive shell.
dircolors_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dircolors.zsh"
if [ ! -s "$dircolors_cache" ] || [ "$dircolorsdb" -nt "$dircolors_cache" ]; then
	if has_command dircolors; then
		dircolors -b "$dircolorsdb" > "$dircolors_cache"
	elif shell_is_macos && has_command gdircolors; then
		gdircolors -b "$dircolorsdb" > "$dircolors_cache"
	fi
fi
[ -s "$dircolors_cache" ] && source "$dircolors_cache"
unset dircolors_cache dircolorsdb
