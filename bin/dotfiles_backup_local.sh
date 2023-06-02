#!/usr/bin/env bash
# Make a backup of the local dotfiles branch as a git formatted patch.
# Ideally put this as a cronjob: 0 13 * * * dotfiles_backup_local.sh

DOTFILES_DIR=$HOME/src/github.com/erikw/dotfiles
BAK_DIR=$HOME/bak/dotfiles
PATCH_FMT="${BAK_DIR}/dotfiles-local-%s.patch"

cd $DOTFILES_DIR
test -d "$BAK_DIR" || mkdir -p "$BAK_DIR"
timestamp=$(date "+%Y-%m-%d-%H%M%S")
patch_file=$(printf "$PATCH_FMT" "$timestamp")

git format-patch --output "$patch_file" main..local
if [ $? -eq 0 ]; then
	echo "Backed up as patch: ${patch_file}"
else
	echo "Could not create patch." >&2
	exit 1
fi
