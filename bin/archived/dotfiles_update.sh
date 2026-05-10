#!/usr/bin/env sh

set -e	# Exit on error

cd $HOME/src/github.com/erikw/dotfiles
git stash
git switch main
git fetch
git rebase origin/main
git switch local
git rebase main
git stash pop || :
./install --only clean link
