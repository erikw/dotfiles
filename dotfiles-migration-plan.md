# Dotfiles Migration Plan: Dotbot to Shell Scripts

## Scope and Goals

This plan migrates the repository away from Dotbot and into a simple, explicit, Bash-based installer architecture.

### Goals

- Remove dependency on Dotbot and Dotbot plugins
- Replace YAML-driven behavior with readable shell scripts
- Keep setup idempotent and safe for existing user files
- Make execution step-based and easy to debug
- Preserve XDG-first layout and current behavior from install.conf.yaml
- Keep dependencies minimal and avoid framework-like complexity

## Target Architecture

### Entry Point

- Primary entry point remains:
  - ./install.sh

### Proposed Structure

- install.sh  ← everything lives here

### Design Principles Applied

- Explicit step functions instead of a declarative DSL
- All code in one file: install.sh, organized by well-named functions
- Shared helpers only for cross-cutting concerns (logging, detection, symlink safety)
- No over-generic plugin framework
- One obvious place to look for any behavior

## Migration Strategy

## Phase 0: Baseline and Safety

1. Keep existing Dotbot setup intact while building the new installer in parallel.
2. Build and validate each shell step independently.
3. Only remove Dotbot files/submodules after parity checks pass.

## Phase 1: Foundation

1. Write helper functions at the top of install.sh
   - logging helpers
   - OS detection
   - environment classification (workstation vs non-workstation)
2. Write symlink helper functions in install.sh
   - idempotent symlink creation
   - conflict backup to ~/.backup
   - unlink/restore support

## Phase 2: Step Implementation

Implement each feature as a step function inside install.sh:

1. step_submodules
2. step_dirs
3. step_link
4. step_codespaces
5. step_macos
6. step_asdf
7. step_crontab
8. step_ghq
9. step_unlink (manual only)

## Phase 3: New install.sh Dispatcher

1. Rewrite install.sh from scratch as a single self-contained file.
2. Define all helpers, symlink functions, and step functions in one file.
3. Main logic at the bottom: parse -s/--step argument.
4. Run one step or all default steps in dependency order.
5. Exclude reversal steps (like unlink) from default run.

## Phase 4: Dotbot Removal

1. Remove Dotbot submodule entries from .gitmodules.
2. Remove .local/repos/dotbot subtree.
3. Remove .config/dotbot/install.conf.yaml.
4. Update README to describe new architecture and usage.

## Detailed Step-by-Step Plan

## Step 1: Shared Helpers (top of install.sh)

### 1.1 Logging and detection functions

Provide simple helper functions:

- log_info, log_warn, die
- is_macos, is_linux, is_debian_like
- is_codespaces
- is_workstation

Environment model:

- Default is workstation
- Codespaces automatically classified as non-workstation
- Keep classification logic centralized so future additions are easy

### 1.2 Symlink helper functions

Implement:

- ensure_parent_dir DEST
- is_expected_symlink DEST SRC
- backup_existing DEST
- create_or_replace_symlink SRC DEST
- remove_symlink DEST
- restore_backup_if_present DEST

Backup behavior:

- If destination exists and is not the expected symlink:
  - move to ~/.backup/<dest-relative-to-home>
  - create intermediate backup directories as needed
  - emit warning message
- If destination already matches expected symlink: no-op

Undo behavior:

- unlink step removes managed symlinks
- if backup exists for the target path, restore it

## Step 2: Submodule Initialization

### 2.1 step_submodules (in install.sh)

Responsibilities:

- sync submodule metadata
- initialize/update required submodules under .local/repos

Reasoning:

- preserves current behavior that other shell config depends on submodules
- runs before linking so paths are ready

## Step 3: Directory Creation

### 3.1 step_dirs (in install.sh)

Create required directories idempotently:

- ~/dl
- ~/pub
- ~/src
- ~/tmp
- ~/.local/share/tig
- ~/.backup

Notes:

- make 0700 where appropriate for private dirs
- no errors if directory already exists

## Step 4: Symlink Management

### 4.1 step_link (in install.sh)

Keep symlink map in a clear array structure:

Core links:

- .bashrc -> ~/.bashrc
- .config -> ~/.config
- .hushlogin -> ~/.hushlogin
- .local/repos -> ~/.local/repos
- .zshenv -> ~/.zshenv
- bin -> ~/bin

macOS-only links:

- .config/Code/User/keybindings.json -> ~/Library/Application Support/Code/User/keybindings.json
- .config/Code/User/settings.json -> ~/Library/Application Support/Code/User/settings.json
- .config/Code/User/snippets -> ~/Library/Application Support/Code/User/snippets
- .config/Code/User/tasks.json -> ~/Library/Application Support/Code/User/tasks.json

Execution behavior:

- create missing parent directories
- replace stale symlinks safely
- backup conflicting files/dirs to ~/.backup
- skip if already correct

### 4.2 step_unlink (in install.sh)

- uses same managed link list as link step
- removes symlinks created by installer
- restores backups where present
- never included in default all-steps execution

## Step 5: Environment-Specific Steps

### 5.1 step_codespaces (in install.sh)

Guard:

- run only when Codespaces detected

Actions:

- apt update
- install minimal required packages currently needed from Dotbot config (tig)

### 5.2 step_macos (in install.sh)

Guard:

- run only on macOS

Actions:

1. run bin/macos_install.sh
2. run Brewfile setup for .config/homebrew/Brewfile
3. run optional host-specific Brewfile if present
4. run bin/macos_config.sh
5. apply macOS-only symlink actions currently done via shell commands in Dotbot config (idempotently)

## Step 6: Workstation-Only Tooling Steps

### 6.1 step_asdf (in install.sh)

Guard:

- skip in non-workstation environments

Actions:

- ensure plugins exist: ruby, python, golang, nodejs
- install latest versions idempotently
- set global/universal versions idempotently

### 6.2 step_crontab (in install.sh)

Guard:

- skip in non-workstation environments

Actions:

- ensure monthly crontab backup entry exists
- ensure daily dotfiles backup entry exists
- avoid duplicate lines

### 6.3 step_ghq (in install.sh)

Guard:

- skip in non-workstation environments

Actions:

- ensure required repos are present via ghq
- no-op if already cloned

## Step 7: install.sh CLI and Dispatcher

## CLI Requirements

- ./install.sh
- ./install.sh -s link
- ./install.sh --step link
- ./install.sh -h
- ./install.sh --help

Behavior:

- with --step: run only selected step
- without --step: run default steps in fixed order
- reject unknown step names with clear message
- -h/--help: print usage, all arguments, and a table of all steps with descriptions; then exit 0

## Proposed Default Execution Order

1. submodules
2. dirs
3. link
4. codespaces (conditional)
5. macos (conditional)
6. asdf (workstation only)
7. crontab (workstation only)
8. ghq (workstation only)

Reversal step excluded by default:

- unlink

## Suggested Shell Architecture and Conventions

- use strict mode in main entry and step scripts:
  - set -o errexit
  - set -o nounset
  - set -o pipefail
- keep functions short and task-specific
- prefer explicit loops and conditionals over metaprogramming
- quote variables consistently
- centralize path roots once in install.sh
- keep symlink mapping readable and close to link logic
- avoid hidden side effects between steps

## Idempotency Rules

Each step must satisfy:

- Safe to run repeatedly
- No duplicate cron entries
- No repeated reinstall actions when already satisfied
- No re-creating identical symlinks
- No destructive overwrite of user files without backup

## Risk Areas and Mitigations

1. Existing ~/.config directory in Codespaces
   - Mitigation: backup-and-replace logic for non-symlink destinations
2. Paths containing spaces (VS Code settings links)
   - Mitigation: strict quoting everywhere
3. Submodule/link ordering
   - Mitigation: always run submodules before link in default order
4. Host-specific package behavior differences
   - Mitigation: isolate OS logic into explicit steps
5. asdf command/version differences
   - Mitigation: keep asdf logic conservative and explicit

## Testing Strategy

## Unit-like Script Validation

- shellcheck install.sh
- manually test helper functions in isolated shell sessions where useful

## Step-Level Functional Testing

1. link step on clean environment
2. link step again to verify no-op behavior
3. conflict case: create real file at a managed destination and verify backup to ~/.backup
4. unlink step and verify restore behavior
5. macos step on macOS host
6. codespaces step inside Codespaces/devcontainer
7. workstation-only steps skipped in non-workstation env

## End-to-End Testing

- run full installer twice on same machine
- compare resulting symlink targets and key side effects
- verify no duplicate cron lines and no unnecessary repeated operations

## Suggestions to Simplify Current Repo Structure

1. Remove Dotbot-specific config directory once migration is complete
   - remove .config/dotbot/install.conf.yaml
2. Remove Dotbot submodules and plugin tree entirely
   - simplify .gitmodules and reduce submodule complexity
3. Keep existing OS scripts as dedicated implementation details
   - retain bin/macos_install.sh and bin/macos_config.sh
4. Keep one canonical installer contract
   - install.sh only
5. Keep link map and all step logic in install.sh
   - one file to open and read; easier audits and future edits

## Completion Criteria

Migration is complete when:

- install.sh no longer invokes Dotbot
- all required behavior from install.conf.yaml is available via shell steps
- Dotbot files/submodules are removed
- repeated runs are idempotent
- step CLI works for targeted execution and debugging
- existing user files are safely backed up when conflicts occur
