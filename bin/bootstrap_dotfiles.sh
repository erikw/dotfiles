#!/usr/bin/env bash
# Boot strap my dotfiles by setting up Git with SSH keys and then cloning and install my dotfiles repo.

set -euxo pipefail

SSH_ID_DIR="$HOME/.ssh/identityfiles"
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
ssh-keygen -t rsa -f $SSH_ID_DIR/github_id_rsa -C "${USER}@${HOSTNAME} for erikw@github"

cat << EOF >> $HOME/.ssh/config

Host *github.com
	Port 22
	User git
	IdentityFile ${SSH_PUB_KEY}
	IdentitiesOnly yes
	ServerAliveInterval 15
EOF

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

gh_email=""
while [ -z "$gh_email" ]; do
	echo -n "Enter your GitHub email: "
	read gh_email
done;
mkdir -p $HOME/.config/git
cat << EOF > $HOME/.config/git/config-local
[user]
	email = $gh_email
EOF


step "Cloning dotfiles repo"
mkdir -p $REPOS_ROOT
git clone $DOTFILES_REPO $DOTFILES_ROOT
cd $DOTFILES_ROOT

step "Bootstrap done"
echo "Now please:"
printf "\t1. Run OS-specific installer scripts e.g. \n"
printf "\t\t~/bin/macos_config.sh \n"
printf "\t\t~/bin/macos_install.sh \n"
printf "\t\t~/bin/windows_install.ps1 \n"
printf "\t2. Configure dotfiles with ./install.sh \n"
