# Environment: General
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# Documentation {{
# PURPOSE
#   Defines **core, tool-independent environment variables** and basic shell
#   context used across the entire system.
#
#   This file establishes foundational values that other parts of the config
#   rely on (especially helper functions and rc/* files).
#
# RESPONSIBILITIES
#   ✔ Set locale and encoding
#     - LANG (UTF-8, required for proper terminal behavior)
#
#   ✔ Detect and expose platform information
#     - SHELL_PLATFORM derived from $OSTYPE
#     - Used by helper functions (e.g. shell_is_*)
#
#   ✔ Define stable, user-specific directory shortcuts
#     - SCANNED (scanned documents)
#     - SCREENSHOTS
#     - GITHUB (code workspace root)
#
#   ✘ DO NOT put here:
#     - Tool/language-specific configuration (→ env/programs.zsh)
#     - PATH modifications for external tools
#     - Aliases or interactive shell behavior
#     - Anything requiring external commands or binaries
#
# WHY
#   These values are:
#     - used globally across scripts and interactive shells
#     - referenced by other config (functions, aliases, etc.)
#
#   Keeping them centralized here ensures:
#     - consistency across environments
#     - minimal duplication
#
# STARTUP CONTEXT
#   Loaded during:
#     → .zshenv (always)
#
#   So it affects:
#     - interactive shells
#     - non-interactive shells (scripts, cron, ssh commands)
#
# RULE OF THUMB
#   "Is this a stable, global value that other config depends on?"
#     → YES → put it here
#
#   "Is this tied to a specific tool or runtime?"
#     → YES → put it in env/programs.zsh
# }}

# Locale.
# Needs to include encoding as well for iTerm: https://gitlab.com/gnachman/iterm2/-/issues/10879#note_1433417922
export LANG=en_US.UTF-8

# Used by $ZDOTDIR/functions/shell_is_*
export SHELL_PLATFORM=unknown
case "$OSTYPE" in
    *linux*)   SHELL_PLATFORM=linux   ;;
    *darwin*)  SHELL_PLATFORM=macos   ;;
    *freebsd*) SHELL_PLATFORM=freebsd ;;
    *bsd*)     SHELL_PLATFORM=bsd     ;;
    *msys*)    SHELL_PLATFORM=windows ;;
esac

# Nice to have when fetching scanned documents
export SCANNED=$HOME/media/images/scanned/
# Ditto screenshots
export SCREENSHOTS=$HOME/media/images/screenshots/

# Set envvar to my Github clones directory, use same base path as $(git config --global ghq.root)
# Nice to have to be able to: $ cd $GITHUB/proj
export GITHUB=$HOME/src/github.com/erikw
