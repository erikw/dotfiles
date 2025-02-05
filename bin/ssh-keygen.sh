#!/usr/bin/env bash
# Interactivly create SSH keypairs with my preferences.
# # NOTE don't use alias for github.com since lot's of applications will break like git submodule and vundle. Just use 'Host "*github.com"'.

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

is_macos() {
  [[ "$OSTYPE" == "darwin"* ]]
}

only_key=n
test "$1" = "--only-key" && only_key=y

alias=""
while [ -z "$alias" ]; do
	echo -n "Alias the remote the host: "
	read alias
done;

hostname=""
while [ -z "$hostname" ]; do
	echo -n "Hostname for the remote the host: "
	read hostname
done;

echo -n "Port nummer [22]: "
read port
if [ -z "$port" ]; then
	port="22"
fi

echo -n "Username for the remote the host [${USER}]: "
read user
if [ -z "$user" ]; then
	user="$USER"
fi


echo -n "Encryption algorithm [-t ed25519]: "
read algo
if [ -z "$algo" ]; then
	algo="ed25519"
fi


echo -n "Additonal comments? (-C): "
read comments
if [ -n "$comments" ]; then
	comments=": ${comments}"
fi

key_stem="${alias}_id_${algo}"
cmd_keygen="ssh-keygen -t ${algo} -f \$HOME/.ssh/identityfiles/${key_stem} -C \"${USER}@${HOSTNAME} for ${user}@${alias}${comments}\""
echo "$cmd_keygen"
echo -n "OK [Y/n]: "
read ok
if !([ -z "$ok" ] || [[ "$ok" = [yY] ]]); then
	exit
fi


if ! [ -d $HOME/.ssh ]; then
	mkdir $HOME/.ssh
	chmod 700 $HOME/.ssh
fi

if ! [ -d $HOME/.ssh/identityfiles ]; then
	mkdir $HOME/.ssh/identityfiles
	chmod 700 $HOME/.ssh/identityfiles
fi

eval "$cmd_keygen"


test "$only_key" = "y" && exit

$SCRIPTPATH/ssh-config-create.sh

cat << EOF >> $HOME/.ssh/config

Host ${alias}
	Hostname ${hostname}
	Port ${port}
	User ${user}
	IdentityFile ~/.ssh/identityfiles/${key_stem}
EOF

cmd_copy="ssh-copy-id -i \$HOME/.ssh/identityfiles/${key_stem}.pub ${user}@${hostname} -p ${port}"
echo "$cmd_copy"
echo -n "[Y/n]: "
read ok
if ([ -z "$ok" ] || [[ "$ok" = [yY] ]]); then
	eval "$cmd_copy"
fi


is_macos && apple_keychain=--apple-use-keychain || apple_keychain=
cmd_agent="ssh-add ${apple_keychain} \$HOME/.ssh/identityfiles/${key_stem}"
echo "$cmd_agent"
echo -n "[Y/n]: "
read ok
if ([ -z "$ok" ] || [[ "$ok" = [yY] ]]); then
	eval $(ssh-agent)
	eval "$cmd_agent"
fi
