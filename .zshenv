# ZSH envionment variables (always read by zsh)

# Make zsh respect XDG
# Reference: https://wiki.archlinux.org/title/XDG_Base_Directory#
# Reference: https://stackoverflow.com/a/46962370/265508
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:=$HOME/.config}

if [ "$CODESPACES" = true ]; then
  # At least in the Codespaces situation, ZDOTDIR is set to $HOME and this we don't want.
  export ZDOTDIR=${XDG_CONFIG_HOME}/zsh
else
  export ZDOTDIR=${ZDOTDIR:=${XDG_CONFIG_HOME}/zsh}
fi

#source $ZDOTDIR/.zshenv
