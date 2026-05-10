#!/usr/bin/env bash
# Modeline {{
#	vi: foldmarker={{,}} foldmethod=marker foldlevel=0
# }}
# Dotfiles installer.
# Usage: ./install.sh [-h|--help] [-s|--step <step>]
# NOTE make sure this script is idempotent!

# Script setup {{
set -o errexit
set -o nounset
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace
# }}

# Constants {{
SCRIPT_NAME=${0##*/}

# shellcheck disable=SC2034  # used by step functions defined below
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.backup"
# }}

# Helpers {{
# Logging {{

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
# }}

# OS / environment detection {{

is_macos()       { [[ "$OSTYPE" == darwin* ]]; }
is_linux()       { [[ "$OSTYPE" == linux* ]]; }
is_windows()     { [[ "$OSTYPE" == cygwin* || "$OSTYPE" == msys* || "$OSTYPE" == win32 ]]; }
is_debian_like() { [[ -f /etc/debian_version ]]; }
is_codespaces()  { [[ "${CODESPACES:-}" == "true" ]]; }
is_workstation() { ! is_codespaces && [[ -z "${CI:-}" ]]; }
# }}

# Symlink helpers {{

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
# }}

# Crontab helpers {{
# Shared state: crontab_current must be initialized by step_crontab before calling
# these helpers. With set -u active, using them without initialization will produce
# an "unbound variable" error — intentional, as a misuse safety net.

# Install the crontab header idempotently, keyed by MARKER ($1).
# Reads and updates crontab_current.
install_crontab_header() {
  local marker="$1"
  if printf '%s\n' "$crontab_current" | grep -Fq "$marker"; then
    log_info "Crontab header already present."
    return 0
  fi
  log_info "Installing crontab header..."
  local tab_header
  # read returns non-zero at EOF of a heredoc — temporarily allow that.
  set +o errexit
  read -r -d '' tab_header <<EOF
${marker}
# Environment
# ~/ works, but \$HOME does not in crontab.
PATH=~/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:/sbin:/usr/sbin:/usr/bin:/bin
# Reference: crontab(5)  Helper: https://crontab.guru/
# Fields: minute hour mday month wday  command
EOF
  set -o errexit
  if [[ -n "$crontab_current" ]]; then
    tab_header="$(printf '%s\n%s\n' "$crontab_current" "$tab_header")"
  fi
  printf '%s\n' "$tab_header" | crontab -
  # Refresh so subsequent add_cron_entry calls see the updated crontab.
  set +o errexit
  crontab_current="$(crontab -l 2>/dev/null)"
  set -o errexit
}

# Add a single crontab entry idempotently, keyed by CMD ($2).
# Reads and updates crontab_current.
add_cron_entry() {
  local schedule="$1" cmd="$2"
  if printf '%s\n' "$crontab_current" | grep -qF "$cmd"; then
    log_info "Crontab entry already present: $cmd"
  else
    crontab_current="$(printf '%s\n%s %s\n' "$crontab_current" "$schedule" "$cmd")"
    printf '%s\n' "$crontab_current" | crontab -
    log_info "Added crontab entry: $schedule $cmd"
  fi
}
# }}
# }}

# Step functions {{

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

# Step: dirs
# Create required directories idempotently.
# ~/.backup and ~/.local/share/tig are private (0700); the rest are normal (0755).
step_dirs() {
  local -a private_dirs=(
    "$BACKUP_DIR"
    "$HOME/.local/share/tig"   # XDG_DATA_HOME for tig; https://wiki.archlinux.org/title/XDG_Base_Directory#Partial
    "$HOME/.local/share/gnupg" # GNUPGHOME must be 0700 or gpg refuses to use it
  )
  local -a normal_dirs=(
    "$HOME/pub"
    "$HOME/src"
    "$HOME/tmp"
  )
  # ~/dl is managed as a symlink to ~/Downloads on macOS; don't create it as a real dir.
  is_macos || normal_dirs+=("$HOME/dl")

  for d in "${private_dirs[@]}"; do
    if [[ ! -d "$d" ]]; then
      mkdir -p "$d"
      chmod 0700 "$d"
      log_info "Created (0700): $d"
    else
      log_info "Already exists: $d"
    fi
  done

  for d in "${normal_dirs[@]}"; do
    if [[ ! -d "$d" ]]; then
      mkdir -p "$d"
      log_info "Created: $d"
    else
      log_info "Already exists: $d"
    fi
  done
}

# Step: link / unlink
# Managed symlinks are defined in two arrays:
#   SYMLINKS_CORE  — always applied
#   SYMLINKS_MACOS — applied on macOS only
# Each entry is "repo-relative-source:absolute-destination".

SYMLINKS_CORE=(
  ".bashrc:$HOME/.bashrc"
  ".config:$HOME/.config"
  ".hushlogin:$HOME/.hushlogin"
  ".local/repos:$HOME/.local/repos"
  ".zshenv:$HOME/.zshenv"
  "bin:$HOME/bin"
  # gpg reads config from GNUPGHOME (~/.local/share/gnupg), not ~/.config/gnupg
  ".config/gnupg/gpg.conf:$HOME/.local/share/gnupg/gpg.conf"
  ".config/gnupg/gpg-agent.conf:$HOME/.local/share/gnupg/gpg-agent.conf"
)

SYMLINKS_MACOS=(
  ".config/Code/User/keybindings.json:$HOME/Library/Application Support/Code/User/keybindings.json"
  ".config/Code/User/settings.json:$HOME/Library/Application Support/Code/User/settings.json"
  ".config/Code/User/snippets:$HOME/Library/Application Support/Code/User/snippets"
  ".config/Code/User/tasks.json:$HOME/Library/Application Support/Code/User/tasks.json"
)

apply_links() {
  local action="$1"  # "link" or "unlink"
  shift
  local entries=("$@")
  for entry in "${entries[@]}"; do
    local src="${entry%%:*}"
    local dest="${entry#*:}"
    if [[ "$action" == "link" ]]; then
      create_or_replace_symlink "$DOTFILES_DIR/$src" "$dest"
    else
      remove_symlink "$dest"
    fi
  done
}

step_link() {
  apply_links link "${SYMLINKS_CORE[@]}"
  if is_macos; then
    apply_links link "${SYMLINKS_MACOS[@]}"
  fi
}

step_unlink() {
  apply_links unlink "${SYMLINKS_CORE[@]}"
  if is_macos; then
    apply_links unlink "${SYMLINKS_MACOS[@]}"
  fi
}

# Step: codespaces
# Install the minimal apt packages the dotfiles need when running inside GitHub
# Codespaces.  Skipped everywhere else.
step_codespaces() {
  is_codespaces || { log_info "Not Codespaces — skipping."; return 0; }
  if ! command -v apt-get >/dev/null 2>&1; then
    log_warn "apt-get not available in this Codespaces image — skipping package install."
    return 0
  fi
  log_info "Installing apt packages for Codespaces..."
  sudo apt-get update -qq
  sudo apt-get install -y tig # tmux
}

# Step: debian
# Install packages via apt on Debian/Ubuntu workstations.
# Package list is read from .config/apt/packages.txt — blank lines, lines
# starting with #, and trailing comments are all ignored.
# Skipped on non-Debian systems and inside Codespaces (handled by step_codespaces).
step_debian() {
  is_debian_like || { log_info "Not Debian-like — skipping."; return 0; }
  is_codespaces  && { log_info "Codespaces — skipping debian step (see step_codespaces)."; return 0; }
  local pkg_file="$DOTFILES_DIR/.config/apt/packages.txt"
  [[ -f "$pkg_file" ]] || die "Package list not found: $pkg_file"
  # Strip blank lines, comment-only lines, and trailing comments; collect into array.
  local -a packages
  while IFS= read -r line; do
    line="${line%%#*}"         # strip trailing comment
    line="${line//[$'\t ']/}"  # remove all tabs and spaces
    [[ -n "$line" ]] && packages+=("$line")
  done < "$pkg_file"
  log_info "Installing ${#packages[@]} apt packages from $pkg_file..."
  sudo apt-get update -qq
  sudo apt-get install -y "${packages[@]}"
}

# Step: linux
# Enable systemd user units shipped in .config/systemd/user/.
# Skipped on non-Linux systems and inside Codespaces.
step_linux() {
  is_linux    || { log_info "Not Linux — skipping."; return 0; }
  is_codespaces && { log_info "Codespaces — skipping linux step."; return 0; }

  log_info "Reloading systemd user daemon..."
  systemctl --user daemon-reload

  local unit_dir="$DOTFILES_DIR/.config/systemd/user"
  local unit
  while IFS= read -r unit_path; do
    unit="$(basename "$unit_path")"
    if systemctl --user is-enabled "$unit" >/dev/null 2>&1; then
      log_info "systemd unit already enabled: $unit"
    else
      log_info "Enabling systemd unit: $unit"
      systemctl --user enable "$unit_path"
    fi
  done < <(find "$unit_dir" -maxdepth 1 -type f)
}

# Step: macos
# Full macOS setup: Homebrew, Brewfile, system config, and iCloud symlinks.
# Skipped on non-macOS systems.
step_macos() {
  is_macos || { log_info "Not macOS — skipping."; return 0; }

  # ── 1. Homebrew ────────────────────────────────────────────────────────────
  if ! [[ -e /opt/homebrew/bin/brew || -e /usr/local/bin/brew ]]; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  local brew_bin
  if [[ -e /opt/homebrew/bin/brew ]]; then
    brew_bin=/opt/homebrew/bin/brew          # Apple Silicon
  elif [[ -e /usr/local/bin/brew ]]; then
    brew_bin=/usr/local/bin/brew             # Intel
  else
    die "Homebrew not found after install attempt."
  fi
  eval "$("$brew_bin" shellenv)"
  local brew_prefix
  brew_prefix="$("$brew_bin" --prefix)"

  # ── 2. Set Homebrew zsh as the login shell ─────────────────────────────────
  # Reference: https://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/
  local brew_zsh="$brew_prefix/bin/zsh"
  local cur_sh
  cur_sh="$(dscl . -read "/Users/$USER" UserShell | cut -d' ' -f2)"
  if [[ "$cur_sh" != "$brew_zsh" ]]; then
    log_info "Setting Homebrew zsh as the default shell..."
    if ! grep -qxF "$brew_zsh" /etc/shells; then
      log_info "Registering $brew_zsh in /etc/shells..."
      echo "$brew_zsh" | sudo tee -a /etc/shells >/dev/null
    fi
    sudo dscl . -create "/Users/$USER" UserShell "$brew_zsh"
  else
    log_info "Default shell already set to Homebrew zsh."
  fi

  # ── 3. Homebrew autoupdate ─────────────────────────────────────────────────
  # Reference: https://github.com/Homebrew/homebrew-autoupdate
  local autoupdate_plist="$HOME/Library/LaunchAgents/com.github.domt4.homebrew-autoupdate.plist"
  local autoupdate_label="com.github.domt4.homebrew-autoupdate"
  mkdir -p "$HOME/Library/LaunchAgents"
  # (Re)start autoupdate when: plist is absent (first run), or plist exists but
  # the launchd service is not loaded (e.g. after a system restart without auto-login).
  if ! [[ -e "$autoupdate_plist" ]] || ! launchctl print "gui/$UID/$autoupdate_label" >/dev/null 2>&1; then
    log_info "Configuring brew autoupdate (every 12 h, including casks)..."
    brew tap homebrew/autoupdate
    brew autoupdate start 43200 --upgrade --cleanup
  fi
  brew autoupdate status

  # ── 4. tmux-256color terminfo ──────────────────────────────────────────────
  # macOS ships an outdated terminfo DB that lacks tmux-256color.
  # Use Homebrew's tic (not /usr/bin/tic) — macOS's bundled tic can't read stdin via -.
  if ! toe -a 2>/dev/null | grep -q '^tmux-256color'; then
    log_info "Compiling tmux-256color terminfo entry..."
    "$brew_prefix/opt/ncurses/bin/infocmp" tmux-256color \
      | "$brew_prefix/opt/ncurses/bin/tic" -xe tmux-256color -
  else
    log_info "tmux-256color terminfo already present."
  fi

  # ── 5. Qlty CLI ────────────────────────────────────────────────────────────
  # Reference: https://docs.qlty.sh/cli/quickstart
  if ! command -v qlty >/dev/null 2>&1; then
    log_info "Installing qlty CLI..."
    curl -fsSL https://qlty.sh | sh
  else
    log_info "qlty already installed."
  fi

  # ── 6. Brewfile ────────────────────────────────────────────────────────────
  log_info "Running Brewfile..."
  brew bundle --file="$DOTFILES_DIR/.config/homebrew/Brewfile"

  local host_brewfile
  host_brewfile="$HOME/.config/homebrew/Brewfile.$(hostname)"
  if [[ -e "$host_brewfile" ]]; then
    log_info "Running host-specific Brewfile: $host_brewfile"
    brew bundle --file="$host_brewfile"
  fi

  # ── 7. macOS system configuration ─────────────────────────────────────────
  log_info "Running macos_config.sh..."
  "$DOTFILES_DIR/bin/macos_config.sh"

  # ── 8. iCloud / macOS convenience symlinks ─────────────────────────────────
  # These overlay the generic ~/dl and ~/doc dirs created by step_dirs.
  log_info "Creating macOS convenience symlinks..."
  local icloud="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
  create_or_replace_symlink ~/Downloads "$HOME/dl"
  create_or_replace_symlink ~/Documents "$HOME/doc"
  create_or_replace_symlink "$icloud"        "$HOME/icloud"
  create_or_replace_symlink "$icloud/bak"   "$HOME/bak"
  create_or_replace_symlink "$icloud/media" "$HOME/media"
  create_or_replace_symlink "$icloud/work"  "$HOME/work"
}

# Step: asdf
# Install asdf language plugins and their latest versions, then set each as
# the global default.  Skipped in non-workstation environments (e.g. Codespaces)
# where language runtimes are already provided by the dev container image.
step_asdf() {
  is_workstation || { log_info "Non-workstation environment — skipping asdf."; return 0; }
  command -v asdf >/dev/null 2>&1 || die "asdf not found. Install it first (e.g. via Homebrew or the Brewfile)."

  # Source asdf XDG env vars from the shared config (same file xdg.zsh sources).
  # shellcheck source=.config/zsh/env/asdf.sh
  source "$DOTFILES_DIR/.config/zsh/env/asdf.sh"

  local -a plugins=(ruby python golang nodejs)

  for plugin in "${plugins[@]}"; do
    if asdf plugin list | grep -q "^${plugin}$"; then
      log_info "asdf plugin already installed: $plugin"
    else
      log_info "Adding asdf plugin: $plugin"
      asdf plugin add "$plugin"
    fi

    log_info "Installing latest $plugin..."
    asdf install "$plugin" latest

    log_info "Setting global $plugin to latest..."
    asdf set -u "$plugin" latest
  done
}

# Step: crontab
# Install crontab entries for periodic backups.
# Skipped in non-workstation environments.
step_crontab() {
  is_workstation || { log_info "Non-workstation environment — skipping crontab."; return 0; }

  # Read current crontab safely: exit 1 means empty crontab (not an error).
  set +o errexit
  crontab_current="$(crontab -l 2>/dev/null)"
  local crontab_exit=$?
  set -o errexit
  if [[ $crontab_exit -ne 0 && $crontab_exit -ne 1 ]]; then
    die "Could not read current crontab (exit $crontab_exit)."
  fi

  install_crontab_header "#dotfiles-install"
  add_cron_entry "@monthly"   "if_fail_do_notification crontab_backup.sh"
  add_cron_entry "0 13 * * *" "if_fail_do_notification dotfiles_backup_local.sh"
  # add_cron_entry "@monthly"   "if_fail_notify spotify-backup.sh"
}

# Step: ghq
# Clone personal repos via ghq.  No-op for repos already present.
# Skipped in non-workstation environments.
step_ghq() {
  is_workstation || { log_info "Non-workstation environment — skipping ghq."; return 0; }
  command -v ghq >/dev/null 2>&1 || die "ghq not found. Install it first (e.g. via Homebrew or the Brewfile)."

  local -a repos=(
    erikw/templates
    erikw/erikw
    erikw/erikw.me-jekyll
  )

  for repo in "${repos[@]}"; do
    log_info "Ensuring repo: $repo"
    ghq get -p "$repo"
  done
}

# Step: windows
# Full Windows setup via bin/windows_install.ps1.
# Skipped on non-Windows systems.
step_windows() {
  is_windows || { log_info "Not Windows — skipping."; return 0; }
  local script="$DOTFILES_DIR/bin/windows_install.ps1"
  [[ -f "$script" ]] || die "Windows install script not found: $script"
  log_info "Running windows_install.ps1..."
  powershell.exe -ExecutionPolicy Bypass -File "$script"
}
# }}

# Dispatcher {{

# Steps that run automatically, in dependency order.
# Each entry is "name:description".
DEFAULT_STEPS=(
  "submodules:Initialize git submodules under .local/repos"
  "dirs:Create required home directories (~/dl, ~/tmp, etc.)"
  "link:Symlink dotfiles into \$HOME, backing up conflicts"
  "codespaces:Install apt packages needed in Codespaces (Codespaces only)"
  "debian:Install apt packages on Debian/Ubuntu workstations (Debian only)"
  "linux:Enable systemd user units (Linux workstation only)"
  "macos:Homebrew install/Brewfile/system config/iCloud symlinks (macOS only)"
  "windows:Full Windows setup via windows_install.ps1 (Windows only)"
  "asdf:Install asdf language plugins and set global versions (workstation only)"
  "crontab:Install crontab entries for backups (workstation only)"
  "ghq:Clone personal repos via ghq (workstation only)"
)

# Manual-only steps excluded from the default run.
MANUAL_STEPS=(
  "unlink:Remove managed symlinks and restore backups"
)

step_name()        { printf '%s' "${1%%:*}"; }
step_description() { printf '%s' "${1#*:}"; }

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
    printf '  %-2d  %-14s  %s\n' "$i" "$(step_name "$entry")" "$(step_description "$entry")"
    i=$(( i + 1 ))
  done
  cat <<EOF

Manual-only steps (must be requested explicitly with --step):
EOF
  for entry in "${MANUAL_STEPS[@]}"; do
    printf '      %-14s  %s\n' "$(step_name "$entry")" "$(step_description "$entry")"
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
      all_names+=( "$(step_name "$e")" )
    done
    die "Unknown step: '$name'. Available steps: ${all_names[*]}"
  fi
}

main() {
  trap 'die "Interrupted."' INT TERM
  local step=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help) show_help; exit 0 ;;
      -s|--step)
        [[ $# -ge 2 && -n "${2:-}" ]] || die "Option '$1' requires a step name. Run '$SCRIPT_NAME --help' for usage."
        step="$2"
        shift 2
        ;;
      *) die "Unknown argument: '$1'. Run '$SCRIPT_NAME --help' for usage." ;;
    esac
  done

  if [[ -n "$step" ]]; then
    run_step "$step"
  else
    for entry in "${DEFAULT_STEPS[@]}"; do
      run_step "$(step_name "$entry")"
    done
  fi
}

main "$@"
# }}
