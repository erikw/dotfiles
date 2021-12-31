#!/usr/bin/env bash
# Install dotfiles.
#
# The name of this script should adhere to what is usually recognized in automations, see  https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-codespaces-for-your-account


step() {
	local msg="$@"
	printf "\n====================\n"
	printf "> %s\n" "$msg"
}


# Reference: https://stackoverflow.com/a/43919044/265508
a="/$0"; a=${a%/*}; a=${a#/}; a=${a:-.}; BASEDIR=$(cd "$a"; pwd)
cd $BASEDIR

source .config/shell/functions
source .config/shell/functions.d/sourceifexists.sh

step "Setting up git"
# Git
email=
while [ -z "$email" ]; do
	echo -n "Enter email address for ~/.config/git/config-local: "
	read email
done;
cat << EOF >> ~/.config/git/config-local
[user]
	email = $email
EOF
git remote add upstream git@github.com:justone/dotfiles.git
git submodule init
git submodule update
git checkout -b local

step "Installing dotfiles with dfm"
bin/dfm install

step "Listing backed up dotfiles at \$HOME/.backup"
ls -la $HOME/.backup

if program_is_in_path vim && program_is_in_path curl; then
	step "Setting up Vim"
	curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim -c PlugInstall
fi

if program_is_in_path nvim && program_is_in_path curl; then
	step "Setting up Neovim"
	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	nvim -c PlugInstall
fi


if program_is_in_path irssi; then
	step "Untracking ~/.irssi/config for local changes."
	source ~/.config/shell/aliases
	dotf_irssiconf_untrack
fi


# Make tig use $XDG_DATA_HOME. Reference: https://wiki.archlinux.org/title/XDG_Base_Directory#Partial
step "Making tig behave"
mkdir -p ${XDG_DATA_HOME:-$HOME/.local/share}/tig

if program_is_in_path npm ; then
	step "Installing global npm packages."
	$HOME/bin/glob_pkg_install_npm.sh
fi

if program_is_in_path pip ; then
	step "Installing global pip packages."
	$HOME/bin/glob_pkg_install_pip.sh
fi

if program_is_in_path bundle ; then
	step "Installing global gems."
	$HOME/bin/glob_pkg_install_gem.sh
fi
