#!/usr/bin/env bash
# Wrapper for spotify-backup https://github.com/bitsofpancake/spotify-backup

spot_username=GIT-CENSORED

date=$(date --date "-1 sec" "+%Y-%m-%d-%H%M%S")
outdest=$HOME/bak/spotify
outfile="$outdest/${spot_username}_${date}"
outtxt=$outfile.txt
outjson=$outfile.json
backupper=/home/erikw/dev/spotify-backup/spotify-backup.py

[ -d $outdest ] || mkdir -p $outdest

echo "Backing up to .txt"
# Script fails some times...
txtdone=0
n_tries=5
while [ $txtdone -ne 1 ] && [ $n_tries -ge 0 ]; do
	echo "${n_tries} tries left."
	$backupper --format txt $outtxt
	[ $? -eq 0 ] && txtdone=1
	n_tries=$((n_tries-1))
done

echo -e "\n\n\n\n"

echo "Backing up to .json"
jsondone=0
n_tries=5
while [ $jsondone -ne 1 ] && [ $n_tries -ge 0 ]; do
	echo "${n_tries} tries left."
	$backupper --format json $outjson.ugly
	[ $? -eq 0 ] && jsondone=1
	n_tries=$((n_tries-1))
done
jshon < $outjson.ugly > $outjson
rm -f $outjson.ugly
