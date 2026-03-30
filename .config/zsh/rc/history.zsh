# RC: Completion
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

test -d ${XDG_STATE_HOME:-$HOME/.local/state}/zsh || mkdir -p ${XDG_STATE_HOME:-$HOME/.local/state}/zsh
export HISTFILE=${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history
export HISTSIZE=1000000				# How many lines in the current session to remember.
export SAVEHIST=1000000				# How many lines to save to disk. Must be <=HISTSIZE.
# Patterns to exclue. Separate with |. *-matching.
export HISTORY_IGNORE="poweroff|reboot|halt|shutdown|xlogout"

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
