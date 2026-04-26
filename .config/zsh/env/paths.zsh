# Environment: Paths
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# Documentation {{
# PURPOSE
#   Defines and constructs the system PATH.
#
# RESPONSIBILITIES
#   ✔ Add system and user binary directories
#   ✔ Initialize Homebrew environment
#   ✔ Ensure PATH ordering and deduplication
#   ✔ Ensure needed directories exist
#
# IMPORTANT
#   PATH must be constructed carefully:
#     - order matters
#     - avoid duplicates (typeset -U path)
#
# RULE OF THUMB
#   "Does this change where executables are found?"
#     → YES → belongs here
#
# LOADED FROM
#   .zprofile
# }}

typeset -U path		# Don't add entry to path if it's already present.
typeset -U fpath	# Don't add entry to fpath if it's already present. Set here already as $(brew shellenv) will modify it.

# Binary paths {{
export PATH			# Make the path available in subshells. Export is only needed once.

# Homebrew (must run BEFORE path array setup — brew shellenv on Homebrew 5.x
# produces no output if it detects its prefix paths are already in PATH).
brew_bin=
if [ -e /opt/homebrew/bin/brew ]; then  # Apple Silicon macs
	brew_bin=/opt/homebrew/bin/brew
elif [ -e /usr/local/bin/brew ]; then  # Intel Macs
	brew_bin=/usr/local/bin/brew
elif [ -e /home/linuxbrew/.linuxbrew/bin/brew ]; then  # Linux
	brew_bin=/home/linuxbrew/.linuxbrew/bin/brew
fi
if [ -n "$brew_bin" ]; then
	# Cache brew shellenv output to avoid subprocess on every login shell.
	brew_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/brew_shellenv.zsh"
	if [ ! -s "$brew_cache" ] || [ "$brew_bin" -nt "$brew_cache" ]; then
		test -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh" || mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
		echo "$(${brew_bin} shellenv)" > "$brew_cache"
	fi
	source "$brew_cache"
	unset brew_cache
fi
unset brew_bin

path=(
  /usr/local/bin
  /usr/local/sbin
  /usr/sbin
  /sbin
  $HOME/bin
  $path
)

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
autoload -Uz has_command sourceifexists $ZDOTDIR/functions/shell_is_*(:t)
# }}

# Create directories {{
# Ensure completion cache directory exists. Used by "zstyle ':completion:*' cache-path" in rc/completion.zsh
test -d ${XDG_CACHE_HOME:-$HOME/.cache}/zsh || mkdir -p ${XDG_CACHE_HOME:-$HOME/.cache}/zsh

# Ensure XDG path for zsh history exist. Used by $HISTFILE will in rc/history.zsh
test -d ${XDG_STATE_HOME:-$HOME/.local/state}/zsh || mkdir -p ${XDG_STATE_HOME:-$HOME/.local/state}/zsh

# Personal log folder used by some program configurations.
test -d ${XDG_STATE_HOME:-$HOME/.local/state}/tmux || mkdir -p ${XDG_STATE_HOME:-$HOME/.local/state}/tmux
#test -d ${XDG_STATE_HOME:-$HOME/.local/state}/irssi || mkdir -p ${XDG_STATE_HOME:-$HOME/.local/state}/irssi
# }}
