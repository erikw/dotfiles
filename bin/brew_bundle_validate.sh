#!/usr/bin/env bash
# Validate all managed Homebrew Brewfiles without installing anything.
# By default this validates syntax/token parsing only.
# Pass --strict to also check that every declared dependency is installed.

set -o errexit
set -o nounset
set -o pipefail

brewfiles=(".config/homebrew/Brewfile")
shopt -s nullglob
for brewfile in .config/homebrew/Brewfile.*; do
	brewfiles+=("$brewfile")
done
shopt -u nullglob

strict=0
if [[ "${1-}" == "--strict" ]]; then
	strict=1
fi

for brewfile in "${brewfiles[@]}"; do
	echo "==> Parsing ${brewfile}"
	HOMEBREW_NO_AUTO_UPDATE=1 brew bundle list --all --file "${brewfile}" >/dev/null
	if [[ "$strict" -eq 1 ]]; then
		echo "==> Checking installed dependencies in ${brewfile}"
		HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --file "${brewfile}"
	fi
done

echo "All Brewfiles validated."
