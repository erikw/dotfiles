# RC: Zinit Plugin Manager
# Replaces rc/omz.zsh (kept for reference, no longer sourced).
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# Documentation {{
# PURPOSE
#   Bootstraps Zinit and loads all shell plugins.
#   Direct replacement for rc/omz.zsh.
#
# RESPONSIBILITIES
#   ✔ Source zinit from submodule at $HOME/.local/repos/zinit
#   ✔ Declare all plugins (eagerly loaded, no Turbo for simplicity)
#   ✔ Load env.local (secrets) — was in rc/omz.zsh
#
# NOTES
#   - rc/bindings.zsh binds history-substring-search-{up,down} widgets
#   - compinit is called in rc/completion.zsh (after this file)
#   - To regenerate plugin data: zinit update
#
# LOADED FROM
#   .zshrc (interactive only)
# }}

# Secrets (gitignore'd!). Loaded here so they are available to all rc/* files that follow. smart-suggestionsion plugin is the only one currently needing this, but may as well load it for any future plugins that need secrets.
# [ -f "$ZDOTDIR/env.local" ] && source "$ZDOTDIR/env.local"

# Zinit bootstrap {{
ZINIT_HOME="$HOME/.local/repos/zinit"
source "$ZINIT_HOME/zinit.zsh"
# Autoload zinit's completion/annotation functions.
# autoload -Uz _zinit
# (( ${+_comps} )) && _comps[zinit]=_zinit
# }}

# Plugins {{

# Extra completions for many programs, must be before compinit.
# blockf = prevents zinit from immediately modifying $fpath when this plugin loads
# Why this matters:
# - zsh completions are discovered via $fpath during compinit
# - without control, plugins may alter $fpath at unpredictable times
# - blockf makes fpath handling more deterministic and avoids timing/order issues
zinit ice blockf
zinit light zsh-users/zsh-completions

# Prefix-aware history search — replaces OMZ lib/key-bindings.zsh up-line-or-beginning-search.
# rc/bindings.zsh binds the registered widgets to arrow keys and k/j in vicmd.
zinit light zsh-users/zsh-history-substring-search

# Safe paste: loads bracketed-paste-magic so pasted text is not immediately executed.
# Using the OMZ snippet directly (downloads from GitHub, cached by zinit).
# Ref: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/safe-paste
zinit snippet OMZ::plugins/safe-paste/safe-paste.plugin.zsh

# Web search: adds google, github, stackoverflow, duckduckgo, youtube, etc. functions.
# Usage: $ google some query   or   $ duckduckgo privacy search
# Remove this block if you do not use it.
# TODO comment this out, not needed.
zinit snippet OMZ::plugins/web-search/web-search.plugin.zsh

# Suggests previous commands inline (like fish shell)
# TODO try out
# zinit light zsh-users/zsh-autosuggestions

# TODO should add this here?
# zinit light junegunn/fzf

# Replace built-in tab completion with fzf-based selector.
# TODO try out
# zinit light Aloxaf/fzf-tab

# TODO do here?
# zinit light direnv/direnv

# Syntax highlighting — must be the last plugin loaded (wraps ZLE self-insert widget).
# zinit light zsh-users/zsh-syntax-highlighting
# TODO manually try this out.
zinit light zdharma-continuum/fast-syntax-highlighting
# }}
