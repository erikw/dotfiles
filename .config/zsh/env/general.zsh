# Environment: General
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
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
