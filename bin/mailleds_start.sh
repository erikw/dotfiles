#!/usr/bin/env sh
# Start mailleds that will blink LEDs when there are unread emails.
export MAIL="$HOME/.mail/inbox"	# Maildir mailbox to use. It checks the subdir "new".
check_interval=60000000 		# In us.
led=c							# LED to blink c(aps lock), s(croll lock) or n(um pad)
/usr/bin/env mailleds -x --maildir --leds "$led" --interval "$check_interval"
