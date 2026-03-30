#!/usr/bin/env bash
# NOTE archived as of refactoring I discovered it doesn't give any benefits, as tmux-continuum does the right thing in both scenarios. Moved all to ghostty config.

set -o nounset
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

SCRIPT_NAME=${0##*/}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR"

SHELL="${SHELL:-/bin/zsh}"

IFS= read -rd '' USAGE <<EOF || :
Start tmux in ghostty if needed.
Usage: $ ${SCRIPT_NAME} -h

-h\tShow this help text.
EOF

while getopts ":c:h?" opt; do
	case "$opt" in
		:) echo "Option -$OPTARG requires an argument." >&2; exit 1;;
		h|?|*) echo -e "$USAGE"; exit 0;;
	esac
done
shift $((OPTIND - 1))


# If we're in tmux already, or not in ghostty, let's replace this process with a new shell.
if [ -n "${TMUX:-}" ] || [ "${TERM_PROGRAM:-}" != "ghostty" ]; then
	exit 0
fi

# If no tmux server is running -> start it (continuum restores state)
#if ! tmux has-session 2>/dev/null; then
#        exec tmux
#else
#        # tmux is already running: attach to "general" if exists, otherwise create and attach
#        #exec tmux new-session -A -s general
#        # Creating a new window makes ghostty Quick Terminal a bit nicer, that it is more likely to be in a clean window.
#        exec tmux new-session -A -s general \; new-window
#fi

# tmux-continuum will restore session if the tmux server is started.
# Attach to "general" if exists, otherwise create and attach
# Creating a new window makes ghostty [Quick Terminal] a bit nicer, that it is more likely to be in a clean window.
#exec tmux new-session -A -s general \; new-window
exec tmux new-session -A -s general
