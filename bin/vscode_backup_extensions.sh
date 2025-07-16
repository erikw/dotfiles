#!/usr/bin/env bash
# Requiremetns: code(1)
# Another option would be to export the list to my dotfiles repo as in https://anhari.dev/blog/saving-vscode-settings-in-your-dotfiles
# However I manually maintain the source of truth inside VSCode settings.json, so this script is just an extra extra.

set -o errexit
set -o nounset
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

SCRIPT_NAME=${0##*/}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR"



BAK_DIR=$HOME/bak/vscode/
BACKUP_FILE_FMT="${BAK_DIR}/%s-extensions.txt"



test -d "$BAK_DIR" || mkdir -p "$BAK_DIR"
timestamp=$(date "+%Y-%m-%d-%H%M%S")
backup_file=$(printf "$BACKUP_FILE_FMT" "$timestamp")

code --list-extensions > "$backup_file"
if [ $? -eq 0 ]; then
	echo "Backed up extension list to: ${backup_file}"
else
	echo "Could not create export extension list" >&2
	exit 1
fi
