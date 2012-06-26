#!/usr/bin/env sh
# Show regex match.
# Source: UNIX Power Tools 32.17, Greg Ubben.

pattern="$1"; shift
awk 'match($0, pattern) > 0 {
	s = substr($0, 1, RSTART-1)
	m = substr($0, 1, RLENGTH)
	gsub (/[^\b- ]/, " ", s)
	gsub (/./, "^", m)
	printf "%s\n%s%s\n", $0, s, m
}' pattern="$pattern" $*
