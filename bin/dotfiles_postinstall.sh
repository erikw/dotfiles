#!/usr/bin/env bash
# Modeline {
#	vi: foldmarker={,} foldmethod=marker foldlevel=0: tabstop=4:
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
	curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim -c 'PlugInstall | qa'
fi

#if program_is_in_path nvim && program_is_in_path curl; then
#    step "Setting up Neovim"
#    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
#    nvim -c 'PlugInstall | qa'
#fi

# NOPE not needed as of bootstrap https://github.com/wbthomason/packer.nvim#bootstrapping
#if program_is_in_path nvim && program_is_in_path git; then
#    step "Setting up Neovim"
#    git clone --depth 1 https://github.com/wbthomason/packer.nvim "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/pack/packer/start/packer.nvim"
#    nvim -c 'PackerInstall | qa'
#fi

if program_is_in_path git-lfs; then
	# git-lfs must have been installed on the system already.
	step "Installing git-lfs configuration."
	git lfs install
fi


if program_is_in_path irssi; then
	step "Untracking $HOME/.irssi/config for local changes."
	source $HOME/.config/shell/aliases
	dotf_irssiconf_untrack
fi


# Make tig use $XDG_DATA_HOME. Reference: https://wiki.archlinux.org/title/XDG_Base_Directory#Partial
step "Making tig behave"
mkdir -p ${XDG_DATA_HOME:-$HOME/.local/share}/tig

if program_is_in_path tmux ; then
	step "Setting up tmux plugins with tpm."
	tmux new-session -d # Need session before running commands.
	tmux run $HOME/.config/tmux/plugins/tpm/bindings/install_plugins
fi

# Disabled glob_pkg_install_*.sh as asdf handles this.
#if program_is_in_path npm ; then
	#step "Installing global npm packages."
	#$HOME/bin/glob_pkg_install_npm.sh
#fi

#if program_is_in_path pip ; then
	#step "Installing global pip packages."
	#$HOME/bin/glob_pkg_install_pip.sh
#fi

#if program_is_in_path bundle ; then
	#step "Installing global gems."
	#$HOME/bin/glob_pkg_install_gem.sh
#fi

# Perl
# Requirements for ~/bin/rename_sane.sh
step "rename_sane.sh dependency: cpan module Unicode"
#cpan Text::Unidecode
# Non-interactive, answer questions with default. Ref: https://stackoverflow.com/a/977996/265508
PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install Text::Unidecode'
