#!/usr/bin/env bash
# Kill zombies by attaching to their parents.
# Original scripot by Mitch Milner at http://stackoverflow.com/questions/13669597/killing-zombie-process-knowing-pid-in-linux-c

gdb_cmd() {
	local cmd="$1"
	echo "$cmd" >> "$slaylist"
}

zombielist=$(mktemp -t "${0##*/}.zombie.XXX")
slaylist=$(mktemp -t "${0##*/}.slay.XXX")
lastparentid=0

ps -e -o ppid,pid,stat,command | grep Z | sort > "$zombielist"
for LINE in "$(cat "$zombielist")"; do
	parentid=$(echo $LINE | awk '{print $1}')
	zombieid=$(echo $LINE | awk '{print $2}')
	stat=$(echo $LINE | awk '{print $3}')
	cmd=$(echo $LINE | awk '{print $4}')

	# Make sure this is a zombie file and we are not getting a Z from the command field.
	[[ "$stat" =~ "Zl?" ]] && continue
	echo "Slay zombie pid=${zombieid}, cmd=\"${cmd}\""
	echo -n "[Y/n]: "
	read ok </dev/tty
	if !([ -z "$ok" ] || [[ "$ok" = [yY] ]]); then
		continue
	fi

	if [ "$parentid" != "$lastparentid" ]; then
		if [ "$lastparentid" != "0" ]; then
        	gdb_cmd "detach"
		fi
		gdb_cmd "attach $parentid"
    fi
    gdb_cmd "call waitpid ($zombieid,0,0)"
    echo "Logging: Parent: $parentid  Zombie: $zombieid"
	lastparentid="$parentid"
done
if [ "$lastparentid" != "0" ]; then
	gdb_cmd "detach"
fi

if [ $(wc -l < "$slaylist") -gt 0 ]; then
	echo -e "\n\n"
	echo "Slaying zombie processes..."
	gdb -batch -x "$slaylist"
fi
rm "$zombielist" "$slaylist"
