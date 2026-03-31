# ZSH login shell setup (only read by login shell)
# Set up PATH, toolchains, Homebrew, etc. Heavier setup that should be done once and shared for all future zsh sessions.
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# Documentation {{
# PURPOSE
#   Sourced for LOGIN shells (once per session).
#   Used to initialize the *global environment*.
#
# RESPONSIBILITIES
#   ✔ Load environment configuration (env/*.zsh)
#     - PATH setup
#     - language runtimes (asdf, java, go, node, etc.)
#     - toolchain environment variables
#     - SDK initializations
#
#   ✔ Things that should run ONCE, not per shell
#
#   ✘ DO NOT put here:
#     - interactive config (prompt, aliases, keybindings)
#     - completion or UI config
#
# WHY
#   Keeps expensive setup out of `.zshrc`, making shell startup fast.
#
# STARTUP CONTEXT
#   Runs after `.zshenv`, before `.zshrc`, but ONLY for login shells.
#
# RULE OF THUMB
#   "Does this define the environment tools run in?"
#     → YES → belongs here (via env/*.zsh)
#     → NO  → likely belongs in .zshrc
# }}

# Profiling - start {{
# Ref: https://kev.inburke.com/kevin/profiling-zsh-startup-time/
# END in .zshrc
# After running this, inspect result of current shell with:
#
# Get startup time in (us):
# $ tail -1 ~/tmp/startuplog.$$ | cut -d' ''
#
# Find slow steps:
# $ ~/bin/parse_zsh_startup.py ~/tmp/startuplog.$$


#PROFILE_STARTUP=true
#if [ "$PROFILE_STARTUP" = true ]; then
#    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
#    PS4=$'%D{%M%S%.} %N:%i> '
#    exec 3>&2 2>$HOME/tmp/startuplog.$$
#    setopt xtrace prompt_subst
#fi
# }}

# Load environment no "for file in $ZDOTDIR/env/*.zsh; do" because we want xdg.sh to be loaded first as others reference it.
source "$ZDOTDIR/env/xdg.zsh"
source "$ZDOTDIR/env/paths.zsh"
source "$ZDOTDIR/env/general.zsh"
source "$ZDOTDIR/env/programs.zsh"
