#!/usr/bin/env bash
# Interactively upgrade my homebrew system.
# Usage: brew_upgrade.sh
# Requirements:
# - Install cask upgrade command with: $ brew tap buo/cask-upgrade

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


_exec "Updating brew formulas" brew update

outdated=$(brew outdated -v)
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
		_exec "Upgrading brew" brew upgrade
		_exec "The brew doctor says" brew doctor || :		# Sneak around $(set -e) as the doctor command return error code.
	fi
fi

_exec "Upgrade cask apps" brew cu --all
_exec "The brew cask doctor says" brew cask doctor || :
