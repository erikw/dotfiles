#!/usr/bin/env bash
# Modeline {
#	vi: foldmarker={,} foldmethod=marker foldlevel=0
# }
# Installation to be done after dotfiles are installed, and ideally after OS-specific tooling too.
# NOTE this must be non-interactive as it's called from non-interactive dotfiles install.sh

set -euxo pipefail

# cd to dotfiles root
# Reference: https://stackoverflow.com/a/43919044/265508
a="/$0"; a=${a%/*}; a=${a#/}; a=${a:-.}; BASEDIR=$(cd "$a"; pwd)
cd $BASEDIR/..

source .config/shell/functions
source .config/shell/functions.d/sourceifexists.sh


step() {
	local msg="$@"
	printf "\n====================\n"
	printf "> %s\n" "$msg"
}

if program_is_in_path vim && program_is_in_path curl; then
	step "Setting up Vim"
	curl -fLo $HOME/.config/vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim -c 'PlugInstall | qa'
fi

if program_is_in_path git-lfs; then
	# git-lfs must have been installed on the system already.
	step "Installing git-lfs configuration."
	git lfs install
fi

# Make tig use $XDG_DATA_HOME. Reference: https://wiki.archlinux.org/title/XDG_Base_Directory#Partial
step "Making tig behave"
mkdir -p ${XDG_DATA_HOME:-$HOME/.local/share}/tig

# Perl
## Requirements for ~/bin/rename_sane.sh
#step "rename_sane.sh dependency: cpan module Unicode"
##cpan Text::Unidecode
## Non-interactive, answer questions with default. Ref: https://stackoverflow.com/a/977996/265508
#PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install Text::Unidecode'
