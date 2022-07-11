#!/usr/bin/env sh

URL_SSH_KEYGEN=https://raw.githubusercontent.com/erikw/dotfiles/personal/bin/ssh-keygen.sh
SSH_PUB_KEY="$HOME/.ssh/identityfiles/github_id_rsa.pub"
DOTFILES_REPO=git@github.com:erikw/dotfiles.git
DOTFILES_ROOT=$HOME/src/github.com/erikw/dotfiles
step() {
	local msg="$@"
	printf "\n====================\n"
	printf "> %s\n" "$msg"
}

cd /tmp

step "Generating SSH key for GitHub"
curl -O $URL_SSH_KEYGEN
chmod 744 ssh-keygen.sh
./ssh-keygen.sh  --only-key  # TODO add option to be able to specify name, URL on cli. Or find better script, to avoid human input.


cat << EOF > $HOME/.ssh/config

Host *github.com
	Port 22
	User git
	IdentityFile ~/.ssh/identityfiles/github_id_rsa
	IdentitiesOnly yes
	ServerAliveInterval 15
EOF

if type xclip >/dev/null 2>&1
	xclip $SSH_PUB_KEY
	echo "Copied public key to clipboard with xclip"
elif type pbcopy >/dev/null 2>&1
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
git clone $DOTFILES_REPO $DOTFILES_ROOT
cd $DOTFILES_ROOT

step "Running ./install.sh"
/install.sh
