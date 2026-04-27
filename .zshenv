# ZSH environment variables (always read by zsh)
# File source order: https://wiki.archlinux.org/title/Zsh#Startup/Shutdown_files
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# Documentation {{
# PURPOSE
#   This file is sourced for *every* zsh invocation:
#     - interactive shells
#     - non-interactive shells (scripts, ssh commands, cron, etc.)
#
#   It must stay MINIMAL and FAST.
#
# RESPONSIBILITIES
#   ✔ Define core environment variables required everywhere
#     - XDG base directories (XDG_CONFIG_HOME, etc.)
#     - ZDOTDIR (location of this config)
#     - Minimal PATH so basic commands work in scripts
#
#   ✘ DO NOT put here:
#     - Heavy initialization (asdf, sdkman, brew, etc.)
#     - Aliases, keybindings, completions
#     - Anything interactive
#
# WHY
#   This file runs extremely often. Any slowdown here affects:
#     - every script
#     - every subshell
#     - system tools invoking zsh
#
# STARTUP ORDER
#   1. .zshenv   ← YOU ARE HERE (always runs)
#   2. .zprofile (login shells only)
#   3. .zshrc    (interactive shells)
#   4. .zlogin   (login shells, after .zprofile)
#
# RULE OF THUMB
#   "Would this break scripts or be needed in `zsh -c`?"
#     → YES → allowed here (but keep minimal)
#     → NO  → put it elsewhere
# }}

# Make zsh respect XDG
# Reference: https://wiki.archlinux.org/title/XDG_Base_Directory#
# Reference: https://stackoverflow.com/a/46962370/265508

# Set XDG envvars to default values, so that scripts can refer to them (like in ~/.config/nvim/syntax/)
# Reference: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
# Don't use these direclty, but substitute for default value if empty:
# - ${XDG_CONFIG_HOME:-$HOME/.config}
# - ${XDG_DATA_HOME:-$HOME/.local/share}
# - ${XDG_STATE_HOME:-$HOME/.local/state}
# - ${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-$HOME/.local/run}"  # Need to be set for yarn(1).

if [ "$CODESPACES" = true ]; then
  # At least in the Codespaces situation, ZDOTDIR is set to $HOME and this we don't want.
  export ZDOTDIR=${XDG_CONFIG_HOME}/zsh
else
  export ZDOTDIR=${ZDOTDIR:=${XDG_CONFIG_HOME}/zsh}
fi

# Minimal PATH so scripts work.
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$HOME/bin"
