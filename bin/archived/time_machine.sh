#!/usr/bin/env bash
# Make incremental backups with rsyncs hard links facility. Almost works like Apple's Time Machine (which also can hardlink directories in a special mode).
# Probably should be run'd with 'nice -n 15' or such if computer is in use by users.
#
# To use this with OS X:
#	1 .Open Inspector on both disks (if both volumes are mounted as external disks)
# 	2. uncheck "Ignore ownership on this volume"
#
# Old options:
# 	-E copy OS X extended attributes
#	--exclude "*.DS_Store"
#	--exclude "*.Trash" 
#	--exclude "*.Trashes" 
#
# Make a full restore from a backup:
# 	rsync -avz --delete $destination/last/ $source
#
# See how much real space each backup takes:
# 	du -sch $destination/backup-*
#
# Note that there is no trailing slash to the backup destination path.
#
# TODO delete some of the oldest backups if disk usage of $destination exceeds like 80%.

date=$(date --date "-1 sec" "+%Y-%m-%d-%H%M%S")
hostname=$(uname -n)
backup_id="${hostname}_${date}"
source=/
destination=

# Get backup destination from argument, if given.
case $1 in
""|mypassport)
	if [ ! -b /dev/mapper/backup-mypassport_crypt ]; then
		echo "/dev/mapper/backup-mypassport_crypt not found" 1>&2
		exit 1
	fi
	destination="/media/mypassport"
	;;
tmachine)
	if [ ! -b /dev/mapper/backup-tmachine_crypt ]; then
		echo "/dev/mapper/backup-tmachine_crypt not found" 1>&2
		exit 1
	fi
	destination="/media/tmachine"
	;;
mybook)
	if [ ! -b /dev/mapper/crypto-mybook ]; then
		echo "/dev/mapper/crypto-mybook not found" 1>&2
		exit 1
	fi
	destination="/media/mybook"
	;;
esac

rsync 							\
	--archive					\
	--recursive					\
	--verbose					\
	--links						\
	--hard-links					\
	--stats 					\
	--progress 					\
	--human-readable				\
	--ignore-errors					\
	--acls						\
	--xattrs 					\
	--numeric-ids 					\
	--log-file=/var/log/rsync/rsync-${date}.log	\
	--exclude-from=${source}/.backup_exclude	\
	--exclude-from=/home/erikw/.backup_exclude	\
	--exclude-from=/mnt/media/.backup_exclude	\
	--delete 					\
	--delete-excluded 				\
	--ignore-missing-args				\
	--link-dest=${destination}/last 		\
	"$source"					\
	"${destination}/incomplete_backup_${backup_id}"

if [ "$?" -ne 0 ]; then
	echo "rsync failed. Aborting." &1>&2
	exit 1
fi

mv "${destination}/incomplete_backup_${backup_id}" "${destination}/backup_${backup_id}"
rm -f "${destination}/last"
ln -s "${destination}/backup_${backup_id}" "${destination}/last"

printf "OK\n%s backuped to %s\n" $source $destination/backup_$backup_id
exit 0
