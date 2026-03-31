# Erik Westrup's .zshrc
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# Documentation {{
# PURPOSE
#   Sourced for INTERACTIVE shells.
#   This defines the *user experience* of the shell.
#
# RESPONSIBILITIES
#   ✔ Load interactive configuration (rc/*.zsh)
#     - prompt / Oh My Zsh
#     - aliases
#     - completion
#     - keybindings
#     - UI behavior
#     - interactive tools (fzf, etc.)
#
#   ✘ DO NOT put here:
#     - heavy environment setup (asdf, sdkman, etc.)
#     - large PATH modifications
#
# WHY
#   This file runs EVERY time you open a terminal or subshell.
#   Keeping it lightweight = fast shell startup.
#
# STARTUP CONTEXT
#   Runs after:
#     .zshenv → .zprofile → .zshrc
#
# RULE OF THUMB
#   "Does this affect how I interact with the shell?"
#     → YES → belongs here
#     → NO  → belongs in env/
# }}

# Profiling - start {{
# Run:
# $ time zsh -i -c exit

#echo "********************************* START profiling .zshrc "
#zmodload zsh/zprof
# }}

# Custom functions (lazy loaded). Also set in env/paths.zsh; typeset -U fpath deduplicates.
fpath=($ZDOTDIR/functions $fpath)
autoload -Uz $ZDOTDIR/functions/*(:t)

source "$ZDOTDIR/rc/omz.zsh"
source "$ZDOTDIR/rc/options.zsh"
source "$ZDOTDIR/rc/history.zsh"
source "$ZDOTDIR/rc/completion.zsh"

source "$ZDOTDIR/rc/ui.zsh"
source "$ZDOTDIR/rc/bindings.zsh"

source "$ZDOTDIR/rc/tools.zsh"
source "$ZDOTDIR/rc/aliases.zsh"


# Profiling - end {{
#zprof
#echo "********************************* END profiling .zshrc "
# }}
