# RC: Oh My ZSH
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# Documentation {{
# PURPOSE
#   Initializes Oh My Zsh and its plugins/themes.
#
# RESPONSIBILITIES
#   ✔ Define plugins list
#   ✔ Set theme
#   ✔ Load Oh My Zsh framework
#
# NOTES
#   - This is the main entry point for OMZ behavior
#   - Plugins may introduce additional completions, aliases, etc.
#
# RULE OF THUMB
#   "Is this related to OMZ framework?"
#     → YES → belongs here
#
# LOADED FROM
#   .zshrc (interactive only)
# }}

export ZSH="$HOME/.local/repos/ohmyzsh/ohmyzsh"
export ZSH_CUSTOM="$HOME/.local/repos/ohmyzsh/custom" # Custom plugins, themes

DISABLE_AUTO_UPDATE="true"

# Ref: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
#ZSH_THEME="agnoster" # Requiers a patched powerline font.
if [ "$CODESPACES" = true ]; then
	ZSH_THEME="robbyrussell"
else
	#ZSH_THEME="apple" # NOPE, not indicating if last command was non-0.
	#ZSH_THEME="agnoster"
	ZSH_THEME="powerlevel10k/powerlevel10k"
fi

# Ref: https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
plugins=(
	# Built-in plugins
	# dash
	# mosh
	# sudo # not working
	# colored-man-pages
	#ssh-agent # TODO if actually needing this, replace with modern keychain https://github.com/danielrobbins/keychain https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/keychain/README.md
	asdf
	direnv
	safe-paste
	web-search


	# Custom plugins ($ZSH_CUSTOM)
	#zsh-autosuggestions
	#smart-suggestion # requires Go
)


# Plugin config
## smart-suggestions
#export SMART_SUGGESTION_AI_PROVIDER=anthropic
#export SMART_SUGGESTION_KEY="^b"

# ssh-agent plugin requires ~/.ssh to exist, which seems to be the case on Codespaces.
#test -d $HOME/.ssh || mkdir $HOME/.ssh

# Skip compaudit security checks (personal machine).
ZSH_DISABLE_COMPFIX=true

# Let OMZ write zcompdump to XDG cache dir.
test -d ${XDG_CACHE_HOME:-$HOME/.cache}/zsh || mkdir -p ${XDG_CACHE_HOME:-$HOME/.cache}/zsh
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"

# Secrets (gitignore'd!)
# Here because loading smart-suggestions already needs it.
[ -f "$HOME/.config/zsh/env.local" ] && source "$HOME/.config/zsh/env.local"


source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
