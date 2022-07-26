#!/usr/bin/env sh
# Create an ssh base config unless it already exist.
# Extracted from ssh-keygen.sh, so that it can be used also by dotfiels_bootstrap.sh

is_macos() {
  [[ "$OSTYPE" == "darwin"* ]]
}

test -e $HOME/.ssh/config && exit

macos_keychain=
if is_macos; then
	macos_keychain="UseKeychain yes   # Apple Keychain"
fi

cat << EOF > $HOME/.ssh/config
# ~${USER}'s ssh config
# * How to apply the same settings for multiple hosts: https://unix.stackexchange.com/a/168460/19909
# * Jumphost tunneling: https://wiki.gentoo.org/wiki/SSH_jump_host
# * Send local LANG env to server. Note that the server must hav this variable AcceptEnv'd. ssh_config(5).
#	Host *
#		SendEnv LANG
# * ssh-agent on macOS: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent

# Avoid "Connection to $HOST closed." when disconnecting. Refer
# Reference: https://unix.stackexchange.com/a/203346/19909
LogLevel QUIET

# Extra ~/.ssh/known_hosts file e.g. if updated automatically by a script.
#UserKnownHostsFile=~/.ssh/known_host_extra

Host *
	ServerAliveInterval 15
	IdentitiesOnly yes
	AddKeysToAgent yes
	${macos_keychain}
EOF
