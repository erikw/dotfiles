# RC: Options
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# Manual & categories: http://zsh.sourceforge.net/Doc/Release/Options.html
setopt nobeep			# No beeps thanks!

# Changing Directories
setopt autopushd				# Add prev PWD to directory stack.
setopt pushdignoredups			# No duplicates in dirs stack.
setopt pushdtohome				# pushd with no args pushes $HOME.
setopt interactivecomments		# Enable bash-like comments by prefixing a command with '#' to make it a comment.

# Input/Output
unsetopt correct correctall		# Do not encourage sloppy typing.
#setopt nohashdirs				# No need for rehash to find new binaries.
#setopt printexitvalue			# Print abnormal exit status.

# Job Control
setopt longlistjobs		# Display PID when suspending processes.

# Shell Emulation
setopt shnullcmd		# Truncate like in bash e.g. $(>file).
