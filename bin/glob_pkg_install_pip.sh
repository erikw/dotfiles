#!/usr/bin/env sh
# Install global pip packages from a custom requirements file.
# Reference: https://tanzu.vmware.com/developer/guides/gs-python-installing-global-packages/
# To list installed packages, run $ pipx list
# Requirements: pipx

REQ=${XDG_CONFIG_HOME:-$HOME/.config}/pip/global-requirements.txt
if [ -r $REQ ]; then
	#sed 's/#.*//' $REQ | xargs npm install -g
	# Improved support for trailing comments. Reference: https://unix.stackexchange.com/a/384019/19909
	sed '
	  s|[[:blank:]]*#.*||; # remove #comments
	  t prune
	  b
	  :prune
	  /./!d;' $REQ | xargs -n1 pipx install
else
	printf "Could not read %s\n" $REQ
fi
