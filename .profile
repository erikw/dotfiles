# Erik Westrups's bash profile.
# This file is read each time a login shell is started.  All other interactive shells will only read .bashrc; this is particularly important for language settings.

# vi: foldmarker={,} foldmethod=marker foldlevel=4: tabstop=4 shiftwidth=4:

# Read global configuration.
if [ -f /etc/profile ]; then
	source /etc/profile
fi

if [ -f $HOME/.shell_profile ]; then
	source $HOME/.shell_profile
fi

# Source bashrc. Most of the settings there are relevant also for login shells.
if [ -n "$BASH" ] && [ -f $HOME/.bashrc ]; then
    source $HOME/.bashrc
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
