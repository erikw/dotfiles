#!/usr/bin/env sh

set -e	# Exit on error

cd $HOME/src/github.com/erikw/dotfiles
git stash
git switch personal
git fetch
git rebase origin/personal
git switch local
git rebase personal
git stash pop || :
./install --only clean link
