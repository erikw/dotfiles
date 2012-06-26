#!/usr/bin/env bash
# Lockfile template for script execlusitive running.
# From Unix Power Tools section 36.27.

script_name=$(basename $0)
lockfile="/tmp/${script_name}.lock"

lock() {
	until (umask 222; echo $$ > "$lockfile") 2>/dev/null; do
		set x $(ls -l "$lockfile") # Likely to fail when another proccess had done unlock()
		echo "Waiting for user $4 (working since $7 $8 $9)..."
	done
}

unlock() {
	rm -f "$lockfile"
}

lock
sleep 2
echo "I'm execlusive"
sleep 2
unlock
