# ZSH login shell setup (only read by login shell)
# Set up PATH, toolchains, Homebrew, etc. Heavier setup that should be done once and shared for all future zsh sessions.
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# Load environment no "for file in $ZDOTDIR/env/*.zsh; do" because we want xdg.sh to be loaded first as others reference it.
source "$ZDOTDIR/env/xdg.zsh"
source "$ZDOTDIR/env/paths.zsh"
source "$ZDOTDIR/env/general.zsh"
source "$ZDOTDIR/env/programs.zsh"
