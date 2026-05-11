#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

config_home() {
  printf '%s\n' "${XDG_CONFIG_HOME:-$HOME/.config}"
}

data_home() {
  printf '%s\n' "${XDG_DATA_HOME:-$HOME/.local/share}"
}

package_file() {
  case "${1:?missing tool name}" in
    python) printf '%s/mise/packages/default-python.txt\n' "$(config_home)" ;;
    node) printf '%s/mise/packages/default-node.txt\n' "$(config_home)" ;;
    ruby) printf '%s/mise/packages/default-ruby.txt\n' "$(config_home)" ;;
    go) printf '%s/mise/packages/default-go.txt\n' "$(config_home)" ;;
    *) printf 'Unsupported tool: %s\n' "$1" >&2; return 1 ;;
  esac
}

trim_whitespace() {
  local line="${1:-}"
  line="${line#"${line%%[![:space:]]*}"}"
  line="${line%"${line##*[![:space:]]}"}"
  printf '%s\n' "$line"
}

load_packages() {
  local file="${1:?missing package file}" line
  PACKAGES=()

  [[ -f "$file" ]] || {
    printf 'Package file not found: %s\n' "$file" >&2
    return 1
  }

  printf 'Reading default packages from: %s\n' "$file"

  while IFS= read -r line || [[ -n "$line" ]]; do
    line="$(trim_whitespace "$line")"
    [[ -n "$line" ]] || continue

    case "$line" in
      \#*)
        continue
        ;;
    esac

    line="$(printf '%s\n' "$line" | sed -E 's/[[:space:]]+#.*$//')"
    line="$(trim_whitespace "$line")"
    [[ -n "$line" ]] || continue

    PACKAGES+=("$line")
  done < "$file"
}
