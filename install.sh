#!/usr/bin/env bash
# Dotfiles installer.
# Usage: ./install.sh [-h|--help] [-s|--step <step>]
# NOTE make sure this script is idempotent!


set -o errexit
set -o nounset
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace


# ──────────────────────────────────────────────────────────────────────────────
# Core constants
# ──────────────────────────────────────────────────────────────────────────────
SCRIPT_NAME=${0##*/}

# shellcheck disable=SC2034  # used by step functions defined below
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.backup"

# ──────────────────────────────────────────────────────────────────────────────
# Logging
# ──────────────────────────────────────────────────────────────────────────────

# Emit color codes only when stdout is a terminal.
if [[ -t 1 ]]; then
  _CLR_INFO='\033[0;36m'   # cyan
  _CLR_WARN='\033[0;33m'   # yellow
  _CLR_STEP='\033[0;32m'   # green
  _CLR_ERR='\033[0;31m'    # red
  _CLR_OFF='\033[0m'
else
  _CLR_INFO='' _CLR_WARN='' _CLR_STEP='' _CLR_ERR='' _CLR_OFF=''
fi

log_info() { printf "${_CLR_INFO}[info]${_CLR_OFF}  %s\n"  "$*"; }
log_warn() { printf "${_CLR_WARN}[warn]${_CLR_OFF}  %s\n"  "$*" >&2; }
log_step() { printf "${_CLR_STEP}[step]${_CLR_OFF}  %s\n"  "$*"; }
die()      { printf "${_CLR_ERR}[error]${_CLR_OFF} %s\n"   "$*" >&2; exit 1; }

# ──────────────────────────────────────────────────────────────────────────────
# OS / environment detection
# ──────────────────────────────────────────────────────────────────────────────

is_macos()       { [[ "$OSTYPE" == darwin* ]]; }
is_linux()       { [[ "$OSTYPE" == linux* ]]; }
is_debian_like() { [[ -f /etc/debian_version ]]; }
is_codespaces()  { [[ "${CODESPACES:-}" == "true" ]]; }
is_workstation() { ! is_codespaces; }

# ──────────────────────────────────────────────────────────────────────────────
# Symlink helpers
# ──────────────────────────────────────────────────────────────────────────────

# Create the parent directory of DEST if it does not exist.
ensure_parent_dir() {
  local dest="$1"
  local parent
  parent="$(dirname "$dest")"
  [[ -d "$parent" ]] || mkdir -p "$parent"
}

# Return true when DEST is already a symlink pointing exactly at SRC.
is_expected_symlink() {
  local src="$1" dest="$2"
  [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]
}

# If DEST exists and is not the expected symlink, move it to $BACKUP_DIR,
# preserving its path relative to $HOME.
backup_existing() {
  local src="$1" dest="$2"
  # Nothing to back up if dest is absent (even as a broken link)
  [[ -e "$dest" || -L "$dest" ]] || return 0
  # Already the correct symlink — nothing to do
  is_expected_symlink "$src" "$dest" && return 0
  local rel="${dest#"$HOME/"}"
  local backup_target="$BACKUP_DIR/$rel"
  mkdir -p "$(dirname "$backup_target")"
  mv "$dest" "$backup_target"
  log_warn "Backed up $dest  →  $backup_target"
}

# Idempotently create a symlink at DEST pointing to SRC.
# Backs up any conflicting file/dir before linking.
create_or_replace_symlink() {
  local src="$1" dest="$2"
  if is_expected_symlink "$src" "$dest"; then
    log_info "Already linked: $dest"
    return 0
  fi
  backup_existing "$src" "$dest"
  ensure_parent_dir "$dest"
  ln -s "$src" "$dest"
  log_info "Linked: $dest  →  $src"
}

# Remove a managed symlink at DEST and restore a backup if one exists.
remove_symlink() {
  local dest="$1"
  if [[ -L "$dest" ]]; then
    rm "$dest"
    log_info "Removed symlink: $dest"
  fi
  restore_backup_if_present "$dest"
}

# Move the backup for DEST back to its original location.
restore_backup_if_present() {
  local dest="$1"
  local rel="${dest#"$HOME/"}"
  local backup_target="$BACKUP_DIR/$rel"
  if [[ -e "$backup_target" ]]; then
    ensure_parent_dir "$dest"
    mv "$backup_target" "$dest"
    log_info "Restored: $backup_target  →  $dest"
  fi
}

# ──────────────────────────────────────────────────────────────────────────────
# Step functions
# ──────────────────────────────────────────────────────────────────────────────

# Step: submodules
# Sync metadata and initialize/update all submodules under .local/repos.
# Scoped to .local/repos so the dotbot subtree (if still present) is included
# but unrelated top-level submodules are not silently pulled in.
step_submodules() {
  log_info "Syncing submodule configuration..."
  git -C "$DOTFILES_DIR" submodule sync --quiet --recursive

  log_info "Updating submodules under .local/repos:"
  grep 'path = \.local/repos' "$DOTFILES_DIR/.gitmodules" | sed 's/.*= //' | while IFS= read -r p; do
    log_info "  $p"
  done

  git -C "$DOTFILES_DIR" submodule update --init --recursive "$DOTFILES_DIR/.local/repos"
}

# ──────────────────────────────────────────────────────────────────────────────
# Dispatcher
# ──────────────────────────────────────────────────────────────────────────────

# Steps that run automatically, in dependency order.
# Each entry is "name:description".
DEFAULT_STEPS=(
  "submodules:Initialize git submodules under .local/repos"
  "dirs:Create required home directories (~/dl, ~/tmp, etc.)"
  "link:Symlink dotfiles into \$HOME, backing up conflicts"
  "codespaces:Install apt packages needed in Codespaces (skip on workstation)"
  "macos:Run Homebrew setup, Brewfile, and macOS config scripts (macOS only)"
  "asdf:Install asdf language plugins and set global versions (workstation only)"
  "crontab:Install crontab entries for backups (workstation only)"
  "ghq:Clone personal repos via ghq (workstation only)"
)

# Manual-only steps excluded from the default run.
MANUAL_STEPS=(
  "unlink:Remove managed symlinks and restore backups"
)

_step_name()        { printf '%s' "${1%%:*}"; }
_step_description() { printf '%s' "${1#*:}"; }

show_help() {
  cat <<EOF
Usage: $SCRIPT_NAME [OPTIONS]

Install and configure dotfiles by running setup steps in order.

Options:
  -s, --step <step>   Run a single named step instead of all default steps.
  -h, --help          Show this help message and exit.

Default steps (run in order when no --step is given):
EOF
  local i=1
  for entry in "${DEFAULT_STEPS[@]}"; do
    printf '  %-2d  %-14s  %s\n' "$i" "$(_step_name "$entry")" "$(_step_description "$entry")"
    (( i++ )) || true
  done
  cat <<EOF

Manual-only steps (must be requested explicitly with --step):
EOF
  for entry in "${MANUAL_STEPS[@]}"; do
    printf '      %-14s  %s\n' "$(_step_name "$entry")" "$(_step_description "$entry")"
  done
  cat <<EOF

Examples:
  $SCRIPT_NAME                   Run all default steps.
  $SCRIPT_NAME --step link       Run only the link step.
  $SCRIPT_NAME --step unlink     Undo managed symlinks and restore backups.
EOF
}

run_step() {
  local name="$1"
  local fn="step_${name//-/_}"
  if declare -f "$fn" > /dev/null 2>&1; then
    log_step "Running step: $name"
    "$fn"
  else
    local all_names=()
    for e in "${DEFAULT_STEPS[@]}" "${MANUAL_STEPS[@]}"; do
      all_names+=( "$(_step_name "$e")" )
    done
    die "Unknown step: '$name'. Available steps: ${all_names[*]}"
  fi
}

main() {
  local step=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help) show_help; exit 0 ;;
      -s|--step) step="${2:-}"; shift 2 ;;
      *) die "Unknown argument: '$1'. Run '$SCRIPT_NAME --help' for usage." ;;
    esac
  done

  if [[ -n "$step" ]]; then
    run_step "$step"
  else
    for entry in "${DEFAULT_STEPS[@]}"; do
      run_step "$(_step_name "$entry")"
    done
  fi
}

main "$@"
