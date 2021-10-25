# Make bash respect XDG.
# It seems like ~/.bashrc is the only file that is reliably loaded i both login and interactive shells (contra ~/.profile or ~/.bash_profile as one would think).
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:=$HOME/.config}
source $XDG_CONFIG_HOME/bash/bashrc
