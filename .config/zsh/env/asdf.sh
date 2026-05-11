# asdf XDG-compliant environment variables.
# Sourced by .config/zsh/env/xdg.zsh (zsh login shell) and install.sh (bash),
# so must use :- defaults and avoid shell-specific syntax.
# Reference: https://github.com/asdf-vm/asdf/issues/687

# asdf core
export ASDF_CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/asdfrc"
export ASDF_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/asdf"
# Hack for avoiding having $HOME/.tool-versions: https://github.com/asdf-vm/asdf/issues/1248#issuecomment-1155978678
export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME=.local/share/asdf/tool-versions

# Plugin default-packages files
export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/default-python-packages.txt"
export ASDF_NPM_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/default-node-packages.txt"
export ASDF_GEM_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/default-ruby-gems.txt"
export ASDF_GOLANG_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/default-go-packages.txt"
