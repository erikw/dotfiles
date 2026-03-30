# Environment: Interactive Tools
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# Travis cli client. https://github.com/travis-ci/travis.rb
sourceifexists $HOME/.travis/travis.sh

# broot - https://dystroy.org/broot/install-br/
sourceifexists "$HOME/.config/broot/launcher/bash/br"

# fzf https://github.com/junegunn/fzf#using-homebrew
if program_is_in_path fzf; then
	# Cache shell init to file to speed up shell initialization.
	fzf_init_file="${XDG_CACHE_HOME:-$HOME/.cache}/fzf.zsh"
	if  [ ! -s "$fzf_init_file" ]; then
		fzf --zsh > "$fzf_init_file"
	fi
	source "$fzf_init_file"
	unset fzf_init_file

	# Default cli options. See fzf(1)
	export FZF_COMPLETION_OPTS='--multi'

	# Find dot files as well. Reference: https://github.com/junegunn/fzf/issues/634
	if program_is_in_path fd; then
		#export FZF_DEFAULT_COMMAND="rg --hidden --files --glob '!{.git,node_modules}/'"
		#export FZF_DEFAULT_COMMAND='fd --type file --hidden --follow --exclude node_modules'
		export FZF_DEFAULT_COMMAND='fd --type file --hidden --follow'
	elif program_is_in_path fdfind; then # apt-get name
		export FZF_DEFAULT_COMMAND='fdfind --type file --hidden --follow'
	else
		export FZF_DEFAULT_COMMAND='find . -type d \( -path './.git' -o -path './node_modules'  \) -prune -o -print'
	fi
	export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

	# To exclude path:
	#export FZF_DEFAULT_COMMAND="$FZF_DEFAULT_COMMAND --exclude 'vcr_cassettes/'"
	export FZF_DEFAULT_COMMAND="$FZF_DEFAULT_COMMAND --exclude '.git/'"
fi

# direnv: https://direnv.net/
# NOTE migrated to OMZ
#if program_is_in_path direnv; then
#    eval "$(direnv hook zsh)"
#fi

# cd-bookmark. Aliases in $ZDOTDIR/rc/aliases.zsh
#if [ -d ~/.local/repos/cd-bookmark ]; then
#    #fpath=(~/src/github.com/erikw/cd-bookmark/(N-/) $fpath)
#    fpath=(~/.local/repos/cd-bookmark(N-/) $fpath)
#    autoload -Uz cd-bookmark
#fi

# fzf-marks: https://github.com/urbainvaes/fzf-marks
# Done here and not in commons, as it must be after $(bindkeys -v)
if [ -d $HOME/.local/repos/fzf-marks ]; then
	sourceifexists $HOME/.local/repos/fzf-marks/fzf-marks.plugin.zsh
	# --exact --select-1: jump to exact match directly if only match.
	# --nth=1 --delimiter=' : ': only search the bookmark names, not values.
	FZF_MARKS_COMMAND="$FZF_MARKS_COMMAND --exact --select-1 --nth=1 --delimiter=' : '"

	# Be consistent with default fzf behaviour. ctrl-d should close selection window, not delete things.
	FZF_MARKS_DELETE=ctrl-r
fi

# qlty. From $(curl https://qlty.sh | sh)
[ -s "/usr/local/share/zsh/site-functions/_qlty" ] && source "/usr/local/share/zsh/site-functions/_qlty"
export QLTY_INSTALL="$HOME/.qlty"
export PATH="$QLTY_INSTALL/bin:$PATH"
