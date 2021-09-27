#!/usr/bin/env bash
# Interactively upgrade my homebrew system.
# Usage: brew_upgrade.sh
# Requirements:
# - Install cask upgrade command with: $ brew tap buo/cask-upgrade NOPE not anymore.

# Exit script on SIGINT.
set -e

CLI_PREFIX="📦$(tput setaf 1) ======>$(tput sgr0)"

last_step=
_log_start_step() {
	last_step="$@"
	echo "${CLI_PREFIX} ${last_step} -- START"
}

_log_stop_step() {
	printf "\n"
	echo "${CLI_PREFIX} ${last_step} -- DONE"
}

_exec() {
	local msg="$1"
	shift
	local cmd="$@"
	_log_start_step "$msg"
	eval "$cmd"
	_log_stop_step
}

_print() {
	msg="$@"
	echo "${CLI_PREFIX} $msg"
}


_exec "Updating brew" brew update

outdated=$(brew outdated -v | grep -v "\[pinned at .*\]" || :)
if [ -n "$outdated" ]; then
	_print "These packages are outdated: "
	echo "$outdated"

	upgrade=""
	while :; do
		echo -n "${CLI_PREFIX} Upgrade these? [Yn]: "
		read upgrade
		([ -z "$upgrade" ] || [ "$upgrade" = y ] || [ "$upgrade" = Y ] || [ "$upgrade" = n ]) && break
	done
	if [ "$upgrade" != n ]; then
		# --cask and --ignore-pinned are mutual exclusive.
		_exec "Upgrading brew formulas" brew upgrade --formula --ignore-pinned
		_exec "Upgrading brew casks" brew upgrade --cask
		_exec "Removing unused leaf packages" brew autoremove
		_exec "Cleaning up caches" brew cleanup
		_exec "The brew doctor says" brew doctor || :		# Sneak around $(set -e) as the doctor command return error code.
	fi
fi
