#!/usr/bin/env bash
# Boot strap my dotfiles by setting up Git with SSH keys and then cloning and install my dotfiles repo.
# NOTE avoid having exec perm set on this file to not accidentially execute it on a system already set-up.

set -euxo pipefail

SSH_DIR="$HOME/.ssh"
SSH_ID_DIR="$SSH_DIR/identityfiles"
SSH_PUB_KEY="$SSH_ID_DIR/github_id_rsa.pub"
DOTFILES_REPO=git@github.com:erikw/dotfiles.git
REPOS_ROOT="$HOME/src/github.com/erikw"
DOTFILES_ROOT="$REPOS_ROOT/dotfiles"

step() {
	local msg="$@"
	printf "\n====================\n"
	printf "> %s\n" "$msg"
}

cd /tmp

step "Generating SSH key pair for GitHub"
mkdir -p $SSH_ID_DIR
chmod 700 $SSH_DIR
chmod 700 $SSH_ID_DIR
# TODO by not using ssh-keygen.sh, we miss out on the common header there. Extract header gen to a lib?
ssh-keygen -t rsa -f $SSH_ID_DIR/github_id_rsa -C "${USER}@${HOSTNAME} for erikw@github"

cat << EOF >> $HOME/.ssh/config

Host *github.com
	Port 22
	User git
	IdentityFile ${SSH_ID_DIR}/github_id_rsa
	IdentitiesOnly yes
	ServerAliveInterval 15
EOF
# TODO add to ssh-agent in the same way as in ssh-keygen.sh

if type xclip >/dev/null 2>&1; then
	xclip $SSH_PUB_KEY
	echo "Copied public key to clipboard with xclip"
elif type pbcopy >/dev/null 2>&1; then
	pbcopy < $SSH_PUB_KEY
	echo "Copied public key to clipboard with pbcopy"
fi

echo "Paste contents of $SSH_PUB_KEY to https://github.com/settings/keys"
echo "Press enter to continue"
read



step "Cloning dotfiles repo"
mkdir -p $REPOS_ROOT
git clone $DOTFILES_REPO $DOTFILES_ROOT

step "Installing dotfiles"
cd $DOTFILES_ROOT
./install.sh



step "Git email setup"
# Needs to be after dfm-install in install.sh, otherwise this just gets moved to ~/.backup.
git_email=""
while [ -z "$git_email" ]; do
	echo -n "Enter your Git email: "
	read git_email
done;
mkdir -p $HOME/.config/git
cat << EOF > $HOME/.config/git/config-local
[user]
	email = $git_email
EOF
