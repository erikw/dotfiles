# Environment: Programs
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# Documentation {{
# PURPOSE
#   Defines environment for language runtimes and CLI tools.
#
# RESPONSIBILITIES
#   ✔ Language environments:
#     - asdf (Go, Java, Node, etc.)
#     - SDKMAN
#     - Ruby, Python, Perl configs
#
#   ✔ Global tool behavior:
#     - LESS
#     - EDITOR
#     - GPG_TTY
#
#   ✔ PATH extensions required by tools
#
# IMPORTANT
#   Everything here should be:
#     - needed by scripts
#     - relevant outside interactive shells
#
# RULE OF THUMB
#   "Would a script need this environment?"
#     → YES → belongs here
#     → NO  → belongs in rc/
#
# LOADED FROM
#   .zprofile
# }}

#  Golang {{
# Not set, overriden by asdf.
#export GOPATH="$XDG_DATA_HOME/go"
#if [ -d "$GOPATH/bin" ]; then
#    PATH="$GOPATH/bin:$PATH"
#fi

# asdf-golang
# Add asdf shims to env and PATH Ref: https://github.com/asdf-community/asdf-golang
# NOTE this overrides set $GOPATH, $GOROOT & $GOBIN.
sourceifexists ${ASDF_DATA_DIR:-$HOME/.asdf}/plugins/golang/set-env.zsh
if [ -n "$GOBIN" ]; then
	PATH="$GOBIN:$PATH"
fi
# }}

# Java {{
#if [ -e /usr/libexec/java_home ] ; then
	#export JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
	#test $? -eq 0 || unset JAVA_HOME
#fi

# Add ANSI color output to ant.
#if has_command ant; then
	#export ANT_ARGS='-logger org.apache.tools.ant.listener.AnsiColorLogger'
#fi

# asdf
# Set $JAVA_HOME from asdf. Reference: https://github.com/halcyon/asdf-java
#sourceifexists "${ASDF_DATA_DIR:-$HOME/.asdf}/asdf/plugins/java/set-java-home.zsh"
# }}

# Node {{
if [ -d "$XDG_DATA_HOME/npm/bin" ]; then
	export PATH="$XDG_DATA_HOME/npm/bin:$PATH"
fi
# }}

# Ruby {{
# ruby-build: recommended build env.
# Reference: https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
#export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
if has_command ruby-build || has_command asdf ; then
	# For Ruby versions 2.x-3.0
	#export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$HOMEBREW_PREFIX/opt/openssl@1.1"
	# For Ruby versions >=3.1
	export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$HOMEBREW_PREFIX/opt/openssl@3"
fi
# }}

# Python {{
# Python pip binary installation directory (pip3 install --user)
#if shell_is_macos; then
#    PATH="$HOME/Library/Python/3.9/bin:$PATH"
#fi
# }}

# Perl {{
# cpan(1): avoid interactive configuration on first launch.
export PERL_MM_USE_DEFAULT=1
# Custom locallib installation path for modules
# Ref: https://stackoverflow.com/a/41541273/265508
export PERL_BASE="$XDG_DATA_HOME/perl5"
export PERL_MM_OPT="INSTALL_BASE=$PERL_BASE"
export PERL_MB_OPT="--install_base $PERL_BASE"
export PERL5LIB="$PERL_BASE/lib/perl5"
export PATH="$PERL_BASE/bin:$PATH"
export MANPATH="$PERL_BASE/man:$MANPATH"
# }}

# Use THE text editor
if [ "$CODESPACES" = true ]; then
	export EDITOR="code --wait" VISUAL="code --wait" CSHEDIT="code --wait"
elif has_command nvim; then
	export EDITOR=nvim VISUAL=nvim CSHEDIT=nvim
elif has_command vim; then
	export EDITOR=vim VISUAL=vim CSHEDIT=vim
fi

# and the only pager.
export PAGER=less

# Current DE in use.
if shell_is_macos; then
	export DESKTYPE=macos
else
	# LINUX-CONFIG
	# FREEBSD-CONFIG
	export DESKTYPE=dwm
fi

# Brew bundler
if has_command brew; then
	# Not using the Brewfile.lock.json feature.
	export HOMEBREW_BUNDLE_NO_LOCK=1
fi

# A better compiler for C langs.
# Unfortunately still quite some problems e.g. with compiling native extension of $(gem install byebuy)
#if has_command clang; then
	#export CC=clang
	#export CXX=clang++
#fi

# Personal log folder used by some program configurations.
test -d ${XDG_STATE_HOME:-$HOME/.local/state}/tmux || mkdir -p ${XDG_STATE_HOME:-$HOME/.local/state}/tmux
#test -d ${XDG_STATE_HOME:-$HOME/.local/state}/irssi || mkdir -p ${XDG_STATE_HOME:-$HOME/.local/state}/irssi

# Needed for gnupg's gpg(1) to work, thus for git commit signing.
# Only run if a TTY exist (interactice). Still do it here rather than ~/.zsrc as we want to do this once only.
#if has_command gpg && tty -s; then
#  export GPG_TTY=$(tty)
#fi


# Disable macos shell restore feature (/etc/bashrc_Apple_Terminal) that creates e.g. ~/.zsh_session
shell_is_macos && export SHELL_SESSIONS_DISABLE=1

# Speed up dfm by telling it where the source is
test -d "$HOME/src/github.com/erikw/dotfiles" && export DFM_REPO="$HOME/src/github.com/erikw/dotfiles"

# iTerm2 shell integration. Reference: https://www.iterm2.com/documentation-shell-integration.html
#sourceifexists $HOME/.iterm2_shell_integration.zsh


# less(1)
# --RAW-CONTROL-CHARS"	- Display colors.
# --ignore-case"	- Case insensitive search. However using capital letter(s) will enable case sensitive search.
# --status-column"	- Status column with number of lines etc.
#  --LINE-NUMBERS"	- Show line numbers.
export LESS="--RAW-CONTROL-CHARS --ignore-case --status-column"

# Must be at the end of shell init file. but here should do...
if has_command sdk; then
	export SDKMAN_DIR="$HOME/.sdkman"
	[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

# Android SDK
#if [ -d "$HOME/src/android-sdk-linux/" ]; then
	#PATH="$HOME/src/android-sdk-linux/tools/:$HOME/src/android-sdk-linux/platform-tools/:$PATH"
#fi

# Load custom keymap
# NOTE allow me or %wheeler to issue loadkeys with no password.
#if shell_is_linux && [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/loadkeys/keymap" ]; then
	#sudo loadkeys -q ${XDG_CONFIG_HOME:-$HOME/.config}/loadkeys/keymap &>/dev/null
#fi
