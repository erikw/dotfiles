# Source file if it exists. Useful for shell startup scripts used across many systems.
sourceifexists() {
	[ -r "$1" ] && source "$1"
}
export sourceifexists >/dev/null
