#!/usr/bin/env sh
# Install global NPM packages from a custom requirements file.
# To list installed packages, run $ npm list -g --depth=0

REQ=$HOME/.npm-global-requirements.txt
if [ -r $REQ ]; then
	sed 's/#.*//' $HOME/.npm-global-requirements.txt | xargs npm install -g
else
	printf "Could not read %s\n" $REQ
fi
