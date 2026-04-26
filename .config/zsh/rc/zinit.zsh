# RC: Zinit Plugin Manager
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# Documentation {{
# PURPOSE
#   Bootstraps Zinit and loads all shell plugins.
#
# RESPONSIBILITIES
#   ✔ Source zinit from submodule at $HOME/.local/repos/zinit
#   ✔ Install binary tools from GitHub Releases (fzf, fd, bat, ripgrep, direnv)
#   ✔ Declare all shell plugins (eagerly loaded, no Turbo for simplicity)
#   ✔ Load env.local (secrets)
#
# NOTES
#   - compinit is called in rc/completion.zsh (after this file)
#   - Binary tools are fetched from GitHub Releases — no package manager needed.
#     Works on macOS, Linux, and devcontainers alike.
#   - To update all plugins and binaries: zinit update
#
# LOADED FROM
#   .zshrc (interactive only)
# }}

# Secrets (gitignore'd!). Loaded here so they are available to all rc/* files that follow. smart-suggestionsion plugin is the only one currently needing this, but may as well load it for any future plugins that need secrets.
# [ -f "$ZDOTDIR/env.local" ] && source "$ZDOTDIR/env.local"

# Zinit bootstrap {{
ZINIT_HOME="$HOME/.local/repos/zinit"
if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
	echo "zinit not found at $ZINIT_HOME — run the install script" >&2
	return 1
fi
source "$ZINIT_HOME/zinit.zsh"
# Autoload zinit's completion/annotation functions.
# autoload -Uz _zinit
# (( ${+_comps} )) && _comps[zinit]=_zinit
# }}

# Plugins {{

# Binary tools — installed directly from GitHub Releases.
# No package manager needed: works on macOS, Linux, and devcontainers alike.
# Run `zinit update` to update.

# fzf — fuzzy finder. Shell integration (key bindings, completion) configured in rc/tools.zsh.
zinit ice from"gh-r" as"program" pick"fzf"
zinit light junegunn/fzf

# fd — fast alternative to find.
zinit ice from"gh-r" as"program" pick"**/fd"
zinit light sharkdp/fd

# bat — cat with syntax highlighting. Used as MANPAGER in rc/tools.zsh.
zinit ice from"gh-r" as"program" pick"**/bat"
zinit light sharkdp/bat

# ripgrep — fast grep alternative.
zinit ice from"gh-r" as"program" pick"**/rg"
zinit light BurntSushi/ripgrep

# direnv — per-directory env vars. Hook configured in rc/tools.zsh.
zinit ice from"gh-r" as"program" mv"direnv* -> direnv" pick"direnv"
zinit light direnv/direnv

# starship — cross-shell prompt.
# atclone/atpull generates the zsh hook once (avoids eval subprocess on every shell start).
# src sources the cached hook at load time, replacing `eval "$(starship init zsh)"` in .zshrc.
zinit ice from"gh-r" as"program" pick"starship" \
    atclone'./starship init zsh > zhook.zsh' \
    atpull'%atclone' src'zhook.zsh'
zinit light starship/starship

# cloc — count lines of code. Perl script, no compilation needed.
zinit ice as"program" pick"cloc"
zinit light AlDanial/cloc

# rename — Perl-based file renaming (compatible with Ubuntu's rename).
# Perl script, no compilation needed.
zinit ice as"program" pick"rename"
zinit light subogero/rename

# dircolors-solarized — solarized color theme for ls/dircolors.
# Data files only; cloned for the dircolors.256dark file used in rc/ui.zsh.
zinit ice as"null"
zinit light seebi/dircolors-solarized

# tig — text-mode git UI. Requires compilation from source; not suitable for
# zinit binary install. Install via system package manager (brew/apt).

# fzf-marks — bookmark directories with fzf.
# Cloned here for zinit to manage updates, but NOT sourced yet.
# Must load after bindkey -v (rc/bindings.zsh), so it is sourced in rc/tools.zsh.
zinit ice pick"/dev/null"
zinit light urbainvaes/fzf-marks

# Shell plugins

# Extra completions for many programs, must be before compinit.
# blockf = prevents zinit from immediately modifying $fpath when this plugin loads
# Why this matters:
# - zsh completions are discovered via $fpath during compinit
# - without control, plugins may alter $fpath at unpredictable times
# - blockf makes fpath handling more deterministic and avoids timing/order issues
zinit ice blockf
zinit light zsh-users/zsh-completions

# Suggests previous commands inline (like fish shell).
# Accept suggestion the right arrow.
# Ref: https://github.com/zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-autosuggestions

# Replace built-in tab completion with fzf-based selector.
zinit light Aloxaf/fzf-tab

# Syntax highlighting — must be the last plugin loaded (wraps ZLE self-insert widget).
# zinit light zsh-users/zsh-syntax-highlighting
zinit light zdharma-continuum/fast-syntax-highlighting
# }}
