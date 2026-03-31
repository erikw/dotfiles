# RC: Completion
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# Documentation {{
# PURPOSE
#   Configures Zsh completion system.
#
# RESPONSIBILITIES
#   ✔ zstyle completion settings
#   ✔ completion behavior and caching
#   ✔ completion-related tweaks
#
# RULE OF THUMB
#   "Does this affect tab-completion behavior?"
#     → YES → belongs here
#
# LOADED FROM
#   .zshrc
# }}

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
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# Disabled as causes issue with OMZ; doesn't cycle though completons in a menu. Case seems ignored anyways
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

#compinit_regen() {
#    rm -f ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION
#    compinit -d ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION -i
#}

# Let OMZ handle this.
#autoload -Uz compinit
# -C: [shell startup time optimization] ignore checking for new comp files. The dump file will be
#       created if there isn’t one already. NOTE Thus, for new files e.g. added to fpath, manually
#       run once the compinit_regen function above.
# -i: ignore insecure folder/file check, thus include e.g. /usr/local/share/zsh/site-functions
# -d: Use a specific path to the dumpfile.
# Reference: http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Initialization
#compinit -C
#test -d ${XDG_CACHE_HOME:-$HOME/.cache}/zsh || mkdir -p ${XDG_CACHE_HOME:-$HOME/.cache}/zsh
#compinit -d ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION -C


# Add tab completion to daemonize.
if has_command daemonize; then
	compctl -cf daemonize
fi

# Completion for functions {{
# For functions in $ZDOTDIR/functions/

# Complete files on $PATH
compdef _command_names viw
compdef _command_names cdw
# }}
