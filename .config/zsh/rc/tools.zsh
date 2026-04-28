# Environment: Interactive Tools
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# Documentation {{
# PURPOSE
#   Configures interactive CLI tools and enhancements.
#
# RESPONSIBILITIES
#   ✔ Tool integrations (configured here; installed via zinit or system package manager):
#     - starship (prompt init hook — managed here regardless of install method)
#     - fzf
#     - bat
#     - broot
#     - fzf-marks
#     - direnv
#
#   ✔ Interactive-only environment variables
#     (e.g. FZF_DEFAULT_COMMAND, GPG_TTY)
#
# IMPORTANT
#   These tools:
#     - enhance interactive usage
#     - are NOT required for scripts
#
# RULE OF THUMB
#   "Is this only useful when I am actively using the shell?"
#     → YES → belongs here
#
# LOADED FROM
#   .zshrc
# }}

# GPG_TTY — needed for gpg(1) to work in interactive shells (e.g. git commit signing).
# $TTY is a zsh builtin (no subprocess needed, unlike $(tty)).
# Set here rather than env/programs.zsh: only meaningful for interactive shells with a TTY.
# (( $+commands[gpg] )) && export GPG_TTY=$TTY

# starship — cross-shell prompt.
# Cache the init hook to avoid eval "$(starship init zsh)" subprocess on every shell start.
# Works whether starship was installed via Homebrew, zinit, or anything else.
# Regenerated automatically when the starship binary is newer than the cache.
if (( $+commands[starship] )); then
	_starship_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/starship_init.zsh"
	if [[ ! -s "$_starship_cache" ]] || [[ "${commands[starship]}" -nt "$_starship_cache" ]]; then
		starship init zsh >| "$_starship_cache"
	fi
	source "$_starship_cache"
	unset _starship_cache
fi

# bat / batman — interactive pager and man-page styling.
export BAT_THEME="Solarized (light)" # Works for dark mode as well.
if (( $+commands[batman] )); then
	_batman_env_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/batman_env.zsh"
	if [[ ! -s "$_batman_env_cache" ]] || [[ "${commands[batman]}" -nt "$_batman_env_cache" ]]; then
		batman --export-env >| "$_batman_env_cache"
	fi
	source "$_batman_env_cache"
	unset _batman_env_cache
fi

# broot - https://dystroy.org/broot/install-br/
# Define br() directly instead of sourcing the launcher script on every shell.
if (( $+commands[broot] )); then
	br() {
		local cmd cmd_file code
		cmd_file=$(mktemp)
		if broot --outcmd "$cmd_file" "$@"; then
			cmd=$(<"$cmd_file")
			command rm -f "$cmd_file"
			eval "$cmd"
		else
			code=$?
			command rm -f "$cmd_file"
			return "$code"
		fi
	}
fi

# fzf — binary installed via zinit (see zinit.zsh). https://github.com/junegunn/fzf
if (( $+commands[fzf] )); then
	# Cache shell init to file to speed up shell initialization.
	# Regenerate when fzf binary is newer than cache (e.g. after zinit update).
	fzf_init_file="${XDG_CACHE_HOME:-$HOME/.cache}/fzf.zsh"
	if [[ ! -s "$fzf_init_file" ]] || [[ "${commands[fzf]}" -nt "$fzf_init_file" ]]; then
		fzf --zsh > "$fzf_init_file"
	fi
	source "$fzf_init_file"
	unset fzf_init_file

	# Default cli options. See fzf(1)
	export FZF_COMPLETION_OPTS='--multi'

	# Find dot files as well. Reference: https://github.com/junegunn/fzf/issues/634
	if (( $+commands[fd] )); then
		#export FZF_DEFAULT_COMMAND="rg --hidden --files --glob '!{.git,node_modules}/'"
		#export FZF_DEFAULT_COMMAND='fd --type file --hidden --follow --exclude node_modules'
		export FZF_DEFAULT_COMMAND='fd --type file --hidden --follow'
	elif (( $+commands[fdfind] )); then # apt-get name
		export FZF_DEFAULT_COMMAND='fdfind --type file --hidden --follow'
	else
		export FZF_DEFAULT_COMMAND='find . -type d \( -path './.git' -o -path './node_modules'  \) -prune -o -print'
	fi
	export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

	# To exclude path:
	#export FZF_DEFAULT_COMMAND="$FZF_DEFAULT_COMMAND --exclude 'vcr_cassettes/'"
	export FZF_DEFAULT_COMMAND="$FZF_DEFAULT_COMMAND --exclude '.git/'"
fi


# direnv — binary installed via zinit (see zinit.zsh). https://direnv.net/
# Wires _direnv_hook into precmd_functions and chpwd_functions so .envrc files are loaded/unloaded automatically on directory change.
# Hook output is stable between runs, so cache it like fzf/brew to avoid a subprocess on every shell.
# Regenerate when direnv binary is newer than cache (e.g. after zinit update).
if (( $+commands[direnv] )); then
	_direnv_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/direnv_hook.zsh"
	if [[ ! -s "$_direnv_cache" ]] || [[ "${commands[direnv]}" -nt "$_direnv_cache" ]]; then
		direnv hook zsh >| "$_direnv_cache"
	fi
	source "$_direnv_cache"
	unset _direnv_cache
fi

# cd-bookmark. Aliases in $ZDOTDIR/rc/aliases.zsh
#if [ -d ~/.local/repos/cd-bookmark ]; then
#    #fpath=(~/src/github.com/erikw/cd-bookmark/(N-/) $fpath)
#    fpath=(~/.local/repos/cd-bookmark(N-/) $fpath)
#    autoload -Uz cd-bookmark
#fi

# fzf-marks: https://github.com/urbainvaes/fzf-marks
# Sourced here (not in zinit.zsh) because it must load after bindkey -v in rc/bindings.zsh.
# The plugin is cloned and updated by zinit; we source it manually from zinit's plugin directory.
_fzf_marks_plugin="${ZINIT[PLUGINS_DIR]}/urbainvaes---fzf-marks/fzf-marks.plugin.zsh"
if [[ -f "$_fzf_marks_plugin" ]]; then
	# Set before sourcing so the plugin picks them up.
	# Explicit full command (not appending to $FZF_MARKS_COMMAND) avoids
	# the variable being empty and producing "--exact" as the base command.
	# --exact --select-1: jump to exact match directly if only match.
	# --nth=1 --delimiter=' : ': only search the bookmark names, not values.
	FZF_MARKS_COMMAND="fzf --exact --select-1 --nth=1 --delimiter=' : '"
	# Be consistent with default fzf behaviour. ctrl-d should close selection window, not delete things.
	FZF_MARKS_DELETE=ctrl-r
	source "$_fzf_marks_plugin"
fi
unset _fzf_marks_plugin

# qlty. From $(curl https://qlty.sh | sh)
if [ -d "$HOME/.qlty" ]; then
	export QLTY_INSTALL="$HOME/.qlty"
	export PATH="$QLTY_INSTALL/bin:$PATH"
	[ -s "/usr/local/share/zsh/site-functions/_qlty" ] && source "/usr/local/share/zsh/site-functions/_qlty"
fi
