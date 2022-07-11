#!/usr/bin/env bash
# Install dotfiles.
#
# NOTE this must be a non-interactive script, as e.g. it will be run by GitHub Coderspaces.
#
# The name of this script should adhere to what is usually recognized in automations, e.g. GitHub Codespaces.
# For CodeSpaces, see
# * https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-codespaces-for-your-account
# * https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-dotfiles-for-codespaces

set -exo pipefail

step() {
	local msg="$@"
	printf "\n====================\n"
	printf "> %s\n" "$msg"
}


# cd to dotfiles root
# Reference: https://stackoverflow.com/a/43919044/265508
a="/$0"; a=${a%/*}; a=${a#/}; a=${a:-.}; BASEDIR=$(cd "$a"; pwd)
cd $BASEDIR

source .config/shell/functions
source .config/shell/functions.d/sourceifexists.sh


step "Setting up git"
# For non-interactive setups e.g. GitHubCoderspaces. Needed as git submodule init asks about github.com fingerprint.
mkdir -p $HOME/.ssh
ssh-keyscan github.com >> $HOME/.ssh/known_hosts

git remote add upstream git@github.com:justone/dotfiles.git
git submodule init
git submodule update
git checkout -b local

step "clone git submodules"
git submodule init
git submodule update

step "Installing dotfiles with dfm"
bin/dfm install

# Must be after dfm-install, otherwise it gets moved to ~/.backup
# NOTE disabled as this script should work as non-interactive e.g. GitHub Codespaces VSCode setup.
#email=
#while [ -z "$email" ]; do
	#echo -n "Enter email address for ~/.config/git/config-local: "
	#read email
#done;
#cat << EOF >> ~/.config/git/config-local
#[user]
	#email = $email
#EOF

step "Listing backed up dotfiles at \$HOME/.backup"
echo "Please check $HOME/.backup/ & commit changes to the local branch."
ls -la $HOME/.backup

step "Trying post-install configuration of programs"
# e.g. for GitHub Coderspaces, Vim will be installed.
bin/dotfiles_postinstall.sh

step "Install OS-specific tooling"
printf "Run OS-specific installer scripts e.g. \n"
printf "\t$ ~/bin/macos_config.sh \n"
printf "\t$ ~/bin/macos_install.sh \n"
printf "\t$ ~/bin/windows_install.ps1 \n"
