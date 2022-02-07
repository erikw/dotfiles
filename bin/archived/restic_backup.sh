#!/usr/bin/env bash
# Make backup my system with restic to Backblaze B2.
# This script is typically run by: /etc/systemd/system/restic-backup.{service,timer}
# NOTE can suspend with $(kill -TSTP [pid] and continued with $(kill -CONT [pid]. Reference: https://unix.stackexchange.com/a/2112

# Long-running job over night
# $ (restic_backup.sh && shutdown -s now)
# Note the spawning to subshell, so that ^Z suspends both commands and not only the first (in case of needing to pause during the day). https://stackoverflow.com/questions/41712192/how-do-i-suspend-and-resume-a-sequence-of-commands-in-bash

# Exit on failure, pipe failure
set -e -o pipefail -x

# Redirect stdout ( > ) into a named pipe ( >() ) running "tee" to a file, so we can observe the status by simply tailing the log file.
me=$(basename "$0")
now=$(date +%F_%R)
log_dir=${XDG_STATE_HOME:-$HOME/.local/state}/restic
log_file="${log_dir}/${now}_${me}.$$.log"
test -d $log_dir || mkdir -p $log_dir
exec > >(tee -i $log_file)
exec 2>&1

# Clean up lock if we are killed.
# If killed by systemd, like $(systemctl stop restic), then it kills the whole cgroup and all it's subprocesses.
# However if we kill this script ourselves, we need this trap that kills all subprocesses manually.
exit_hook() {
	echo "In exit_hook(), being killed" >&2
	jobs -p | xargs kill
	restic unlock
}
trap exit_hook INT TERM

# How many backups to keep.
RETENTION_DAYS=14
RETENTION_WEEKS=16
RETENTION_MONTHS=12
RETENTION_YEARS=2

# What to backup, and what to not
BACKUP_PATHS="$HOME/ /Volumes/toshiba_music/ /Volumes/wd_games/"

BACKUP_EXCLUDES="--exclude-file ${XDG_CONFIG_HOME:-$HOME/.config}/backup_exclude"
# restic will crash if not all exclude files specified are available.
if [ -d /Volumes/toshiba_music/ ]; then
	BACKUP_EXCLUDES="${BACKUP_EXCLUDES} --exclude-file /Volumes/toshiba_music/.backup_exclude"
fi
if [ -d /Volumes/wd_games/ ]; then
	BACKUP_EXCLUDES="${BACKUP_EXCLUDES} --exclude-file /Volumes/wd_games/.backup_exclude"
fi

BACKUP_TAG=cronjob
VERBOSITY_LEVEL=2

# Set all environment variables like
# B2_ACCOUNT_ID, B2_ACCOUNT_KEY, RESTIC_REPOSITORY etc.
source ${XDG_CONFIG_HOME:-$HOME/.config}/restic/b2_env.sh

# How many network connections to set up to B2. Default is 5.
B2_CONNECTIONS=50



# NOTE start all commands in background and wait for them to finish.
# Reason: bash ignores any signals while child process is executing and thus my trap exit hook is not triggered.
# However if put in subprocesses, wait(1) waits until the process finishes OR signal is received.
# Reference: https://unix.stackexchange.com/questions/146756/forward-sigterm-to-child-in-bash

# Remove locks from other stale processes to keep the automated backup running.
restic unlock &
wait $!

# Do the backup!
# See restic-backup(1) or http://restic.readthedocs.io/en/latest/040_backup.html
# --one-file-system makes sure we only backup exactly those mounted file systems specified in $BACKUP_PATHS, and thus not directories like /dev, /sys etc.
# --tag lets us reference these backups later when doing restic-forget.
restic backup \
	--verbose=${VERBOSITY_LEVEL} \
	--one-file-system \
	--tag $BACKUP_TAG \
	--option b2.connections=$B2_CONNECTIONS \
	$BACKUP_EXCLUDES \
	--exclude-if-present .git \
	$BACKUP_PATHS &
wait $!

# Dereference old backups AND remove them.
# See restic-forget(1) or http://restic.readthedocs.io/en/latest/060_forget.html
# --group-by only the tag and path, and not by hostname. This is because I create a B2 Bucket per host, and if this hostname accidentially change some time, there would now be multiple backup sets.
restic forget \
	--verbose=${VERBOSITY_LEVEL} \
	--tag $BACKUP_TAG \
	--group-by "paths,tags" \
	--prune \
	--keep-daily $RETENTION_DAYS \
	--keep-weekly $RETENTION_WEEKS \
	--keep-monthly $RETENTION_MONTHS \
	--keep-yearly $RETENTION_YEARS &
wait $!

# Remove old data not linked anymore.
# See restic-prune(1) or http://restic.readthedocs.io/en/latest/060_forget.html
# NOTE done by restic-forget now
#restic prune \
#	--option b2.connections=$B2_CONNECTIONS \
#	--verbose &
#wait $!

# Check repository for errors.
# NOTE this takes much time (and data transfer from remote repo?), do this in a separate systemd.timer which is run less often.
#restic check &
#wait $!

echo "Backup & cleaning is done."
