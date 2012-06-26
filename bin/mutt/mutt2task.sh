#!/bin/bash
# Add an email from mutt as a task in taskwarrior. To use this: make a macro in the mutt configuration like:
# macro index t "<pipe-message>mutt2task<enter>"
task add +email E-mail: $(egrep '^Subject|^From' $* | awk -F: '{print $2}' | sed 's/\(.*>\)\(.*\)/\1 - \2/g')
