#!/usr/bin/env bash
# Watch Maildir inboxes for new mails and send a summary notification with notify-send. Tested and "works perfectly" with dunst.
# Author: Erik Westrup https://erikw.me/
# Dependencies:
# - inotifywait: from inotify-tools package
# - email_parse.py: Does a better job of parsing emails than shell hackery.

# Settings.
maildir_path="$HOME/.mail"		# Path to Maildir root.
mailboxes=(inbox lists)			# Mailboxes to watch.

watchdirs=$(for box in ${mailboxes[*]}; do echo ${maildir_path}/$box/new; done)
scriptname=${0##*/}

trim() {
    local var="$1"
    var="${var#"${var%%[![:space:]]*}"}"   # Remove leading whitespace characters.
    var="${var%"${var##*[![:space:]]}"}"   # Remove trailing whitespace characters.
    echo -n "$var"
}

parse_send() {
	local inbox="$1"
	local mailfile="$2"

	# Get parts. Decodes and does MIME, HTML parsing etc.
	local subject=$(email_parse.py --subject "$mailfile")
	local from=$(email_parse.py --from "$mailfile")
	local body=$(email_parse.py --body "$mailfile")

	# Subject length trimming.
	subject=${subject:0:40}
	subject=$(trim "$subject")


	# Prefer display name to email address.
	local from_name=$(echo "$from" | grep -Po "[^<>]+(?=(?:<|$))")
	local from_email=$(echo "$from" | grep -Po "(?<=<).+(?=>)")
	if [ -n "$from_name" ]; then
		from="$from_name"
	elif [ -n "$from_email" ]; then
		from="$from_email"
	else
		from="<unknown>"
	fi

	# From length trimming.
	from=${from:0:30}
	from=$(trim "$from")

	# Work your body.
	# Strip signature.
	body=$(echo "$body" | sed -n '/-- /q;p')
	# Join lines.
	body=$(echo "$body" | tr --squeeze-repeats "\\n" ' ')
	# Squeeze repetitive spaces to get more text.
	body=$(echo "$body" | sed 's/\s\s\+/ /g')
	# Strip leading and trailing spaces.
	body=$(trim "$body")
	# Limit length.
	body=${body:0:110}

	# Format the output.
	local out_summary=$(printf "[%s] From: %s | Subject: %s |\\n" "$inbox" "$from" "$subject")
	local out_body=""
	if [ -n "$body" ]; then
		out_body=$(printf "%s [...]\\n" "$body")
	fi

	# Send the message with the name this scrip was invoked with.
	notify-send --app-name "$scriptname" "$out_summary" "$out_body"
}

# Debug with static file.
if [ -n "$1" ]; then
	parse_send "debugmail"  "$1"
	exit 0
fi

# Let inotifywait monitor changes and output each event on it's own line.
while read mail; do
	# Split inotify output to get path and the file that was added.
	parts=($(echo "$mail" | sed -e 's/ \(CREATE\|MOVED_TO\) / /'))
	inbox_path="${parts[0]}"
	inbox=$(echo "$inbox_path" | grep -Po "(?<=/)\w+(?=/new)")
	mailfile="${parts[1]}"
	parse_send "$inbox"  "${inbox_path}/${mailfile}"
done < <(inotifywait --monitor --event create --event moved_to ${watchdirs} 2>/dev/null)
