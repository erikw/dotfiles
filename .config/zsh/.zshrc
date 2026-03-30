# Erik Westrup's .zshrc
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# Profiling - start {{
# After running this, inspect result of current shell with:
# $ ~/bin/parse_zsh_startup.py ~/tmp/startuplog.$$
# Source: https://kev.inburke.com/kevin/profiling-zsh-startup-time/

#PROFILE_STARTUP=true
#if [ "$PROFILE_STARTUP" = true ]; then
#    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
#    PS4=$'%D{%M%S%.} %N:%i> '
#    exec 3>&2 2>$HOME/tmp/startuplog.$$
#    setopt xtrace prompt_subst
#fi
# }}

# Custom functions (lazy loaded).
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
#if [ "$PROFILE_STARTUP" = true ]; then
#    unsetopt xtrace
#    exec 2>&3 3>&-
#fi
# }}
