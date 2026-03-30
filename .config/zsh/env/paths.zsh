# Environment: Paths
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# Binary paths {{
typeset -U path		# Don't add entry to path if it's already present.
export PATH			# Make the path available in subshells. Export is only needed once.



path=(
  /usr/local/bin
  /usr/local/sbin
  /usr/sbin
  /sbin
  $HOME/bin
  $path
)

# Homebrew
brew_bin=
if [ -e /opt/homebrew/bin/brew ]; then  # Apple Silicon macs
	brew_bin=/opt/homebrew/bin/brew
elif [ -e /usr/local/bin/brew ]; then  # Intel Macs
	brew_bin=/usr/local/bin/brew
elif [ -e /home/linuxbrew/.linuxbrew/bin/brew ]; then  # Linux
	brew_bin=/home/linuxbrew/.linuxbrew/bin/brew
fi
if [ -n "$brew_bin" ]; then
	eval "$(${brew_bin} shellenv)"
fi
unset brew_bin

# Homebrew overrides
if [ -d "$HOMEBREW_PREFIX/opt/sqlite/bin" ]; then
	path=($HOMEBREW_PREFIX/opt/sqlite/bin $path)
fi
if [ -d "$HOMEBREW_PREFIX/opt/curl/bin" ]; then
	path=($HOMEBREW_PREFIX/opt/curl/bin $path)
fi

# Poetry or similar installs
test -d $HOME/.local/bin && path=($HOME/.local/bin $path)

# Add MacTex binaries (macos) to PATH.
# Reference: http://rkrug.github.io/LMS-test/downloads/UpdatingForElCapitan.pdf
test -e /Library/TeX/texbin && path=(/Library/TeX/texbin $path)

# ghq
# https://github.com/motemen/ghq
# Set envvar to my github clones directory, use same base path as
# $(git config --global ghq.root)
export GITHUB=$HOME/src/github.com/erikw


# asdf shims
# ! Should be last prepended to path.
if [ -d "${ASDF_DATA_DIR:-$HOME/.asdf}/shims" ]; then
	path=(${ASDF_DATA_DIR:-$HOME/.asdf}/shims $path)
fi
# }}

# Function paths {{
# Homebrew zsh completions. Reference: https://docs.brew.sh/Shell-Completion
# Some of the completion functions comes from https://github.com/zsh-users/zsh-completions
if [ -d $HOMEBREW_PREFIX/share/zsh-completions ]; then
	fpath=($HOMEBREW_PREFIX/share/zsh-completions $fpath)
fi

# Custom functions (lazy loaded).
fpath=($ZDOTDIR/functions $fpath)
# Load only functions needed at statup shell level.
autoload -Uz program_is_in_path sourceifexists $ZDOTDIR/functions/shell_is_*(:t)

# }}
