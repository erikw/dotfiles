#!/usr/bin/env bash
# Wrapper for spotify-backup https://github.com/caseychu/spotify-backup
# Requirements: jq(1)
# Add a crontab entry like:
# # Run every Sunday evening
# 0     20     *     *     0      if_fail_do_notification spotify-backup.sh


spot_username=erikwestrup

date=$(date --date "-1 sec" "+%Y-%m-%d-%H%M%S")
outdest=$HOME/bak/spotify
outfile="$outdest/${spot_username}_${date}"
outtxt=$outfile.txt
outjson=$outfile.json
backupper=$HOME/src/github.com/caseychu/spotify-backup/spotify-backup.py



# Redirect stdout ( > ) into a named pipe ( >() ) running "tee" to a file, so we can observe the status by simply tailing the log file.
me=$(basename "$0")
log_dir=$XDG_STATE_HOME/spotify-backup
log_file="${log_dir}/${date}_${me}.$$.log"
test -d $log_dir || mkdir -p $log_dir
exec > >(tee -i $log_file)
exec 2>&1


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
jq < $outjson.ugly > $outjson
rm -f $outjson.ugly
