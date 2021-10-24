#!/usr/bin/env sh
# Install global NPM packages from a custom requirements file.
# To list installed packages, run $ npm list -g --depth=0

REQ=$XDG_CONFIG_HOME/npm/global-requirements.txt
if [ -r $REQ ]; then
	#sed 's/#.*//' $HOME/.npm-global-requirements.txt | xargs npm install -g
	# Improved support for trailing comments. Reference: https://unix.stackexchange.com/a/384019/19909
	sed '
	  s|[[:blank:]]*#.*||; # remove #comments
	  t prune
	  b
	  :prune
	  /./!d;' $REQ | xargs npm install -g
else
	printf "Could not read %s\n" $REQ
fi
