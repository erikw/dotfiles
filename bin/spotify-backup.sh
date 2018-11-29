#!/usr/bin/env bash
# Wrapper for spotify-backup https://github.com/caseychu/spotify-backup
# Requirements: jshon(1)


spot_username=GIT-CENSORED

date=$(date --date "-1 sec" "+%Y-%m-%d-%H%M%S")
outdest=$HOME/bak/spotify
outfile="$outdest/${spot_username}_${date}"
outtxt=$outfile.txt
outjson=$outfile.json
backupper=$HOME/src/github.com/caseychu/spotify-backup/spotify-backup.py


exec_with_retry() {
	local n_tries="$1"
	shift
	local cmd="$@"

	local is_done=0
	while [ $is_done -ne 1 ] && [ $n_tries -ge 0 ]; do
		echo "> ${n_tries} tries left."
		eval $cmd
		[ $? -eq 0 ] && is_done=1
		n_tries=$((n_tries-1))
	done
}


[ -d $outdest ] || mkdir -p $outdest
echo "> Backing up to $outtxt"
exec_with_retry 2 $backupper --format txt $outtxt

echo -e "\n\n\n\n"

echo "> Backing up to $outjson"
exec_with_retry 2 $backupper --format json $outjson.ugly
jshon < $outjson.ugly > $outjson
rm -f $outjson.ugly
