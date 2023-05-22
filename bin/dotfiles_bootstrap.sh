#!/usr/bin/env bash
# Boot strap my dotfiles by setting up Git with SSH keys and then cloning and install my dotfiles repo.
# Usage: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/erikw/dotfiles/personal/bin/dotfiles_bootstrap.sh)"
# NOTE avoid having exec perm set on this file to not accidentially execute it on a system already set-up.

set -o errexit
set -o nounset
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace


SSH_DIR="$HOME/.ssh"
SSH_ID_DIR="$SSH_DIR/identityfiles"
SSH_PRIV_KEY="$SSH_ID_DIR/github_id_rsa"
SSH_PUB_KEY="${SSH_PRIV_KEY}.pub"
DOTFILES_REPO=git@github.com:erikw/dotfiles.git
REPOS_ROOT="$HOME/src/github.com/erikw"
DOTFILES_ROOT="$REPOS_ROOT/dotfiles"
SSH_CONFIG_SCRIPT_URL="https://github.com/erikw/dotfiles/blob/personal/bin/ssh-config-create.sh"

is_macos() {
  [[ "$OSTYPE" == "darwin"* ]]
}

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
curl -O https://raw.githubusercontent.com/erikw/dotfiles/personal/bin/ssh-config-create.sh
chmod 744 ssh-config-create.sh
./ssh-config-create.sh
ssh-keygen -t rsa -f $SSH_ID_DIR/github_id_rsa -C "${USER}@${HOSTNAME} for erikw@github"

cat << EOF >> $HOME/.ssh/config

Host *github.com
	Port 22
	User git
	IdentityFile ${SSH_ID_DIR}/github_id_rsa
	IdentitiesOnly yes
	ServerAliveInterval 15
EOF

# Set up ssh-agent
is_macos && apple_keychain=--apple-use-keychain || apple_keychain=
cmd_agent="ssh-add ${apple_keychain} ${SSH_PRIV_KEY}"
eval $(ssh-agent)
eval "$cmd_agent"

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
./install
