#!/usr/bin/env bash
# Enable TouchID on macOS unless it already is. This script should be run after OS updates as the sudo file is reseted then.
# Dependencies: $(brew install pam-reattach) for tmux https://github.com/fabianishere/pam_reattach
# Inspired by: https://mostlymac.blog/2022/03/01/use-jamf-self-service-to-enable-touchid-for-sudo/

# Run this script as sudo. Ref: https://unix.stackexchange.com/a/28794/19909
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

PAM_FILE=/etc/pam.d/sudo
SCRIPT_NAME=$(basename "$0")

read -r -d '' ADDED_MODULES <<-EOF
	# Added by ${SCRIPT_NAME}:
	auth       optional       /opt/homebrew/lib/pam/pam_reattach.so
	auth       sufficient     pam_tid.so

	# Original:
	EOF

timestamp=$(date "+%Y-%m-%d-%H%M%S")

if fgrep -q "pam_tid.so" "$PAM_FILE"; then
	echo "TouchID for sudo is already enabled."
else
	cp $PAM_FILE ${PAM_FILE}.${timestamp}.bak

	echo -e "$ADDED_MODULES" | cat - $PAM_FILE > ${PAM_FILE}.new

	mv ${PAM_FILE}.new $PAM_FILE

	echo "TouchID for sudo is now enabled."
fi
