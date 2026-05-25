# Environment: XDG
# Make programs respect XDG.
# Most $XDG_* vars are set in ~/.zshenv
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# Documentation {{
# PURPOSE
#   Centralizes XDG Base Directory configuration.
#
# RESPONSIBILITIES
#   ✔ Define XDG-related environment variables for programs
#   ✔ Redirect tool configs away from $HOME into XDG paths
#
# EXAMPLES
#   - INPUTRC
#   - GNUPGHOME
#   - DOCKER_CONFIG
#
# RULE OF THUMB
#   "Does this tell a program WHERE to store its files?"
#     → YES → belongs here
#
# LOADED FROM
#   .zprofile (login shell, environment setup phase)
# }}

export INPUTRC=$XDG_CONFIG_HOME/readline/inputrc
export KDEHOME=$XDG_CONFIG_HOME/kde
export MPLAYER_HOME=$XDG_CONFIG_HOME/mplayer
export SCREENRC=$XDG_CONFIG_HOME/screen/screenrc
export CGDB_DIR=$XDG_CONFIG_HOME/cgdb
export GRADLE_USER_HOME=$XDG_DATA_HOME/gradle
export GRIPHOME=$XDG_CONFIG_HOME/grip
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export SQLITE_HISTORY=$XDG_DATA_HOME/sqlite_history
export XINITRC=$XDG_CONFIG_HOME/X11/xinitrc
export ACKRC=$XDG_CONFIG_HOME/ack/ackrc # Project local .ackrc is still possible.
export WGETRC=$XDG_CONFIG_HOME/wget/wgetrc
export GDBHISTFILE=$XDG_DATA_HOME/gdb/history
export SOLARGRAPH_CACHE=$XDG_CACHE_HOME/solargraph
export TRAVIS_CONFIG_PATH=$XDG_CONFIG_HOME/travis
export RIPGREP_CONFIG_PATH=$XDG_CONFIG_HOME/ripgrep/config
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export ANDROID_HOME="$XDG_DATA_HOME"/android
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc

# Remove when issue solved: https://github.com/anthropics/claude-code/issues/1455
export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"

# asdf; Not yet fully compliant: https://github.com/asdf-vm/asdf/issues/687
# source "${XDG_CONFIG_HOME}/zsh/env/asdf.sh"

# Go
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"

# fzf-marks
if [ "$CODESPACES" = true ]; then
	# Pre-coded bookmarks for Codespaces env.
	export FZF_MARKS_FILE=$XDG_CONFIG_HOME/fzf-marks/marks-codespaces
else
	export FZF_MARKS_FILE=$XDG_CONFIG_HOME/fzf-marks/marks
fi

# Octave
export OCTAVE_SITE_INITFILE=$XDG_CONFIG_HOME/octave/octaverc
export OCTAVE_HISTFILE=$XDG_CACHE_HOME/octave-hsts

# XCompose
export XCOMPOSECACHE=$XDG_CACHE_HOME/X11/XCompose
export XCOMPOSEFILE=$XDG_CONFIG_HOME/X11/XCompose

# Bundle
export BUNDLE_USER_CONFIG=$XDG_CONFIG_HOME/bundle/config
export BUNDLE_USER_CACHE=$XDG_CACHE_HOME/bundle
export BUNDLE_USER_PLUGIN=$XDG_DATA_HOME/bundle

# Mailcap. Seems like can use envvar at least for NeoMutt. Ref: https://manpages.debian.org/testing/neomutt/neomutt.1.en.html
export MAILCAPS="$XDG_DATA_HOME:$MAILCAPS"

# AWS cli
#export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
#export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config

# Vim XDG. Ref: https://wiki.archlinux.org/title/XDG_Base_Directory
export GVIMINIT='let $MYGVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/gvimrc" : "$XDG_CONFIG_HOME/nvim/init.gvim" | so $MYGVIMRC'
export VIMINIT='let $MYVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/vimrc" : "$XDG_CONFIG_HOME/nvim/init.lua" | so $MYVIMRC'
