# RC: History
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# Documentation {{
# PURPOSE
#   Configures shell history behavior.
#
# RESPONSIBILITIES
#   ✔ HISTFILE location (XDG-compliant)
#   ✔ history size limits
#   ✔ history options (deduplication, timestamps, etc.)
#
# RULE OF THUMB
#   "Does this affect command history storage or behavior?"
#     → YES → belongs here
#
# LOADED FROM
#   .zshrc
# }}

# No export: these are zsh-internal variables; child processes set their own.
HISTFILE=${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history
HISTSIZE=1000000				# How many lines in the current session to remember.
SAVEHIST=1000000				# How many lines to save to disk. Must be <=HISTSIZE.
# Patterns to exclue. Separate with |. *-matching.
HISTORY_IGNORE="poweroff|reboot|halt|shutdown|xlogout"

setopt appendhistory		# Append to history write on exit, don't overwrite.
setopt histignoredups		# Don't save immediate duplicates lines in history.
setopt histignorespace		# Ignore commands starting with space.
setopt extendedhistory		# Save command time start and exec time in seconds.
setopt histreduceblanks		# Strip redundant spaces.

# Don't save failed commands (mostly misspellings) to history, to avoid getting them on completion later.
# Ref: https://superuser.com/a/902508/42070
zshaddhistory() {
	local j=1
	while ([[ ${${(z)1}[$j]} == *=* ]]) {
		((j++))
	}
	whence ${${(z)1}[$j]} >| /dev/null || return 1
}
