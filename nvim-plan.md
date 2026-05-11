# Neovim: ALE → Native LSP Migration Plan

> Config root: `~/.config/nvim/`  
> Primary files touched: `lua/plugins/development.lua`, `init.lua`  
> This plan is incremental. Each phase is independently testable and reversible.  
> **Do not Commit after every successful phases, let user do that himself..**
> For all setups,chec kthe project's README/documetnation to make sure we setfashion.

---

## Part 1 — Current-State Analysis

### Plugin Manager

`lazy.nvim` is already bootstrapped in `lua/config/lazy.lua`. Plugin specs live in `lua/plugins/` with four files: `general.lua`, `development.lua`, `syntax.lua`, `ui.lua`.

### What Is Already Installed

| Component | Plugin | Status | Notes |
|---|---|---|---|
| Plugin manager | `lazy.nvim` | ✅ installed | Stable, no changes needed |
| Treesitter | `nvim-treesitter` (main) | ✅ installed | `auto_install=true`, highlight via FileType autocmd |
| Snippets | `LuaSnip` + `friendly-snippets` | ✅ installed | Tab-expand keymaps set; no changes needed |
| Auto-pairs | `nvim-autopairs` | ✅ installed | `check_ts=true` — **potential overlap with blink.cmp** |
| LSP (ALE) | `dense-analysis/ale` | ✅ installed | Acts as LSP client (`ale_use_neovim_lsp_api = 0`) |
| Signature help | `lsp_signature.nvim` | ✅ installed | **Replaced by blink.cmp built-in** |
| Symbol sidebar | `vista.vim` | ✅ installed | `vista_default_executive = "ale"` — **must update** |
| Status line | `lualine.nvim` | ✅ installed | No LSP components yet |

### What Is NOT Installed (to add)

- `nvim-lspconfig` ❌
- `mason.nvim` ❌
- `mason-lspconfig.nvim` ❌
- `blink.cmp` ❌
- `conform.nvim` ❌
- `nvim-lint` ❌

---

### ALE LSP Servers → nvim-lspconfig Migration Map

| Language | ALE linter (LSP mode) | Target server | Modernization |
|---|---|---|---|
| Go | gopls | gopls | Keep as-is |
| JavaScript | eslint | eslint-lsp | Via eslint language server |
| JSON | jsonls | jsonls | Keep |
| Python | pyright | **basedpyright** | Upgrade: better type narrowing, stricter by default |
| Ruby | solargraph | **ruby-lsp** | Replace: actively maintained, VS Code-origin |
| Shell | language_server | bashls | Same tool, different ALE alias |
| TeX | texlab | texlab | Keep |
| Vim | vimls | vimls | Keep |
| Lua | *(none — luacheck only)* | **lua_ls** | Add: covers hover, completion, type checking |

### ALE Pure Linters → nvim-lint Migration Map

| Language | ALE linter | Target | Modernization |
|---|---|---|---|
| Python | flake8 | **ruff** | Replace: ruff = flake8 + isort + pyupgrade in one tool |
| Python | *(isort was a fixer)* | **ruff** | Covered by ruff |
| Ruby | rubocop | rubocop | Keep (ruby-lsp also surfaces rubocop diagnostics) |
| Lua | luacheck | lua_ls (built-in) | lua_ls covers most; luacheck optional for extras |

### ALE Fixers → conform.nvim Migration Map

| Language | ALE fixer | conform formatter | Modernization |
|---|---|---|---|
| CSS | prettier | prettier | Keep |
| JavaScript | prettier, eslint | prettier | eslint formatting via LSP |
| JSON | prettier | prettier | Keep |
| Go | gopls, goimports | **goimports** | gopls LSP format handles rest |
| Lua | stylua | stylua | Keep |
| Python | black, isort | **ruff_format** | Replace both with ruff |
| Ruby | rubocop | rubocop | Keep |
| SCSS | prettier | prettier | Keep |
| TypeScript | prettier | prettier | Keep |
| YAML | prettier | prettier | Keep |

### ALE Keymaps → Native LSP Equivalents

| Key | ALE binding | Native LSP target |
|---|---|---|
| `gd` | `ale_go_to_definition` | `vim.lsp.buf.definition()` |
| `gr` | `ale_find_references` | `vim.lsp.buf.references()` |
| `K` | `ale_hover` | `vim.lsp.buf.hover()` |
| `<Space>rn` | `ale_rename` | `vim.lsp.buf.rename()` |
| `<Leader>I` | `ale_import` | `vim.lsp.buf.code_action()` |
| `<C-k>` | `ale_previous_wrap` | `vim.diagnostic.goto_prev()` |
| `<C-j>` | `ale_next_wrap` | `vim.diagnostic.goto_next()` |

### Dependency Graph of Affected Components

```
dense-analysis/ale
 ├── completion (omnifunc) ─────────────── → blink.cmp
 ├── LSP servers ────────────────────────── → nvim-lspconfig + mason
 ├── fixers (format-on-save) ────────────── → conform.nvim
 ├── pure linters ───────────────────────── → nvim-lint
 ├── keymaps (gd/gr/K/etc.) ─────────────── → on_attach in nvim-lspconfig
 └── diagnostic nav (C-k/C-j) ────────────── → vim.diagnostic.*

lsp_signature.nvim ─── depends on ALE LSP ─── → remove, use blink.cmp signature
vista.vim ──────────── executive = "ale" ────── → change to "nvim_lsp"
init.lua DisableFixers ─── ale_fix_on_save ──── → rewrite for conform.nvim
```

---

## Part 2 — Migration Risk Assessment

| Risk | Severity | Mitigation |
|---|---|---|
| Duplicate diagnostics (ALE + native LSP both running) | HIGH | Set `ale_disable_lsp = 1` in Phase 2 before enabling native LSP keymaps |
| Completion breaks (omnifunc → blink.cmp) | HIGH | Test blink.cmp in Phase 3 before removing ALE completion |
| Format-on-save breaks during transition | MEDIUM | Keep `ale_fix_on_save = 1` until conform is verified in Phase 4 |
| `vista.vim` breaks (ALE executive gone) | LOW | Update executive in Phase 6 |
| `lsp_signature.nvim` silent failure | LOW | Remove in Phase 3 alongside ALE completion |
| `DisableFixers` command references `ale_fix_on_save` | LOW | Update in Phase 6 |
| `nvim-autopairs` conflict with `blink.cmp` auto-brackets | MEDIUM | Discussed below — requires your decision |

---

## Part 3 — Plugin Overlap Discussions

### ⚠️ Discussion 1: `nvim-autopairs` vs `blink.cmp` auto-brackets

`blink.cmp` has a built-in `auto_brackets` feature that inserts closing brackets after completing a function/type. `nvim-autopairs` provides:

- Bracket pair insertion on any open bracket (not just completions)
- Treesitter-aware pair checking (`check_ts = true`)
- `<C-h>` and `<C-w>` to delete pairs
- Endwise-style rules (commented out but available)

**Options:**
- **A (recommended)**: Keep `nvim-autopairs`, disable `blink.cmp`'s `auto_brackets`. Avoids duplicate bracket insertion; preserves pair-deletion keymaps.
> Chose this option!
- **B**: Remove `nvim-autopairs`, use `blink.cmp`'s `auto_brackets` only. Simpler stack but loses treesitter-aware pair checking and `<C-h>`/`<C-w>` pair deletion.
- **C**: Keep both (blink.cmp docs show nvim-autopairs integration via event hook).

> **This decision must be made in Phase 3.**

### ⚠️ Discussion 2: `lsp_signature.nvim` vs `blink.cmp` signature

`blink.cmp` includes a built-in signature help window that triggers on `(` in insert mode. `lsp_signature.nvim` provides the same feature but is wired via `BufReadPre` (unusual — normally `LspAttach`) because ALE doesn't fire `LspAttach`.

**Recommendation**: Remove `lsp_signature.nvim` in Phase 3. `blink.cmp`'s built-in signature is equivalent and requires no separate plugin.

---

## Part 4 — Recommended File Structure

No structural changes to the directory layout are needed. All changes happen inside existing files:

- `lua/plugins/development.lua` — primary modification target (add LSP/conform/lint sections, remove/update ALE section)
- `init.lua` — update `DisableFixers` command, remove ALE-specific global opts
- `lazy-lock.json` — auto-updated by lazy.nvim on each phase

Suggested internal section layout for `development.lua` after migration:

```
-- General tools (unchanged)
-- Snippets: LuaSnip (unchanged)
-- Git: fugitive, gitgutter, diffview (unchanged)
-- LSP Core: nvim-lspconfig, mason, mason-lspconfig  ← NEW
-- Completion: blink.cmp                              ← NEW
-- Formatting: conform.nvim                           ← NEW
-- Linting: nvim-lint                                 ← NEW
-- Symbols: vista.vim (updated executive)
-- Treesitter (unchanged)
-- Web/CSS (unchanged)
```

---

## Part 5 — Step-by-Step Implementation Phases

### Phase 0 — Pre-flight

**Before touching anything:**

1. Run `nvim --startuptime /tmp/nvim.log` — record baseline startup time
2. Run `:checkhealth` — save output for comparison
3. `git add -A && git commit -m "chore(nvim): pre-migration baseline snapshot"`

---

### Phase 1 — Add Mason + nvim-lspconfig (ALE Fully Active)

**Goal**: Install LSP infrastructure without changing any existing behavior.  
**Files**: `lua/plugins/development.lua` (add new section, nothing removed)  
**Risk**: Zero. New plugins are inert until `on_attach` keymaps replace ALE's.

**Steps:**

1. Add a new `-- LSP Core` section in `development.lua` with:
   - `mason.nvim` (setup with `ui = { border = "rounded" }`)
   - `mason-lspconfig.nvim` (with `ensure_installed` listing all server names)
   - `nvim-lspconfig` with a minimal `on_attach` that sets NO keymaps yet (ALE still owns them)
2. In the `on_attach`, only configure `vim.lsp.buf.format` capability detection and `vim.diagnostic.config()` for sign display
3. Use `vim.lsp.handlers` to suppress duplicate hover/signature windows (ALE still handles them)
4. Do NOT set `gd`, `gr`, `K` keymaps yet

**Servers to ensure_installed via mason:**
`gopls`, `eslint`, `jsonls`, `basedpyright`, `ruby_lsp`, `bashls`, `texlab`, `vimls`, `lua_ls`

**Rollback**: Delete the three new plugin spec blocks. `:Lazy clean`.

**Validation:**
- [ ] `:Mason` opens without error
- [ ] `:checkhealth mason` passes
- [ ] Open a Go file → `:LspInfo` shows `gopls` attached
- [ ] Open a Python file → `:LspInfo` shows `basedpyright` attached
- [ ] `gd` / `K` still work via ALE (not native LSP yet)
- [ ] No startup errors

---

### Phase 2 — Disable ALE LSP, Enable Native LSP Diagnostics and Keymaps

**Goal**: Stop ALE from running language servers; transfer `gd`/`gr`/`K`/`<Space>rn` to native LSP.  
**Files**: `development.lua` (ALE config section + lspconfig `on_attach`)  
**Risk**: Medium. LSP keymaps change behavior; diagnostics source changes.

**Steps:**

1. In the ALE config block, change:
   - `ale_use_neovim_lsp_api = 0` → `ale_disable_lsp = 1`
   - Remove from `ale_linters` all LSP-based entries (gopls, eslint, jsonls, pyright, solargraph, language_server, texlab, vimls). Keep only pure linters: `luacheck` (lua), `flake8` (python — temporary), `rubocop` (ruby — temporary)
2. In the `nvim-lspconfig` `on_attach`, add all LSP keymaps:
   - `gd` → `vim.lsp.buf.definition()`
   - `gr` → `vim.lsp.buf.references()`
   - `K` → `vim.lsp.buf.hover()`
   - `<Space>rn` → `vim.lsp.buf.rename()`
   - `<Leader>I` → `vim.lsp.buf.code_action()`
   - `<C-k>` → `vim.diagnostic.goto_prev({ wrap = true })`
   - `<C-j>` → `vim.diagnostic.goto_next({ wrap = true })`
   - Add `<Space>ca` → `vim.lsp.buf.code_action()` as a secondary binding
3. Configure `vim.diagnostic.config({ signs = true, virtual_text = true, underline = true })`

**Rollback**: Revert `ale_disable_lsp`, restore `ale_linters`, remove keymaps from `on_attach`.

**Validation:**
- [ ] `gd` on a Go symbol jumps to definition via native LSP
- [ ] `K` shows a floating hover doc
- [ ] `gr` populates the quickfix list with references
- [ ] Diagnostics appear in the sign column
- [ ] No error: `"Cannot serialise boolean: table key must be a number or string"`
- [ ] `:LspInfo` shows servers as active with 0 ALE LSP conflicts

---

### Phase 3 — Add blink.cmp (Replace ALE Completion)

**Goal**: Replace `ale#completion#OmniFunc` with `blink.cmp`.  
**Files**: `development.lua` (new blink section; update ALE completion opts)  
**Risk**: Medium. Completion behavior changes entirely.

**Steps:**

1. Add `blink.cmp` with sources: `lsp`, `luasnip`, `path`, `buffer`
2. Configure `signature.enabled = true` (replaces `lsp_signature.nvim`)
3. Configure `auto_brackets` based on your Decision 1 above:
   - If keeping `nvim-autopairs`: set `auto_brackets.enabled = false`
   - If removing `nvim-autopairs`: set `auto_brackets.enabled = true`
4. Wire LuaSnip as snippet provider in blink.cmp config
5. Remove from the ALE config block:
   - `ale_completion_enabled = 1` (or set to `0`)
   - `vim.opt.omnifunc = "ale#completion#OmniFunc"`
   - `vim.opt.completeopt = { "menu", "preview" }`
6. Remove `lsp_signature.nvim` plugin spec entirely
7. Apply Decision 1: keep or remove `nvim-autopairs`

**Rollback**: Disable blink.cmp, restore ALE completion opts, restore `lsp_signature.nvim`.

**Validation:**
- [ ] Completion popup appears on typing in insert mode
- [ ] LSP candidates appear (function names, types)
- [ ] `<Tab>` expands a LuaSnip snippet
- [ ] `<Tab>` / `<S-Tab>` navigate snippet tabstops
- [ ] Signature help appears when typing `(` after a function name
- [ ] No `omnifunc` errors
- [ ] `lsp_signature.nvim` is no longer in `:Lazy`

---

### Phase 4 — Add conform.nvim (Replace ALE Fixers)

**Goal**: Replace `ale_fixers` and `ale_fix_on_save` with `conform.nvim`.  
**Files**: `development.lua` (new conform section; update ALE fixer config)  
**Risk**: Medium. Format-on-save is critical daily functionality.

**Steps:**

1. Add `conform.nvim` with `formatters_by_ft`:
   - `css` = `{ "prettier" }`
   - `javascript`, `typescript` = `{ "prettier" }`
   - `json` = `{ "prettier" }`
   - `go` = `{ "goimports" }` (gopls handles LSP-format separately)
   - `lua` = `{ "stylua" }`
   - `python` = `{ "ruff_format" }` (replaces black + isort)
   - `ruby` = `{ "rubocop" }`
   - `scss`, `yaml` = `{ "prettier" }`
2. Enable `format_on_save = { timeout_ms = 2000, lsp_fallback = true }`
3. Note `stylua` options: add `--search-parent-directories` to `conform` formatter args (mirrors current `ale_lua_stylua_options`)
4. Note Brewfile exemption: `conform.setup` supports `format_on_save` as a function; skip formatting for `filetype == "brewfile"` (mirrors `ale_pattern_options` Brewfile special case)
5. Set `ale_fix_on_save = 0` (keep ALE fixers defined but disabled)
6. Verify conform works for one week; then remove `ale_fixers` table from ALE config
7. Rewrite `DisableFixers` command in `init.lua` to call conform's disable API:
   ```lua
   vim.api.nvim_create_user_command("DisableFixers",
     'execute "DisableStripWhitespaceOnSave" | lua require("conform").setup({ format_on_save = false })',
     { force = true })
   ```
8. Remove `ALEToggleFixer` command (replaced by `:ConformToggleFormatOnSave` or custom mapping)

**Rollback**: Set `ale_fix_on_save = 1`, comment out conform, revert `DisableFixers`.

**Validation:**
- [ ] Save a `.go` file → imports are organized by goimports
- [ ] Save a `.py` file → ruff_format runs (check that isort-equivalent reordering happens)
- [ ] Save a `.lua` file → stylua formats it (with XDG stylua.toml respected via `--search-parent-directories`)
- [ ] Save a Ruby file → rubocop formats it
- [ ] `:ConformInfo` shows correct formatters per filetype
- [ ] Saving a Brewfile does NOT trigger any formatter
- [ ] `:DisableFixers` prevents format-on-save

---

### Phase 5 — Add nvim-lint (Replace Remaining ALE Linters)

**Goal**: Move non-LSP pure linters from ALE to `nvim-lint`.  
**Files**: `development.lua` (new nvim-lint section; remove remaining ALE linter entries)  
**Risk**: Low. Purely additive diagnostics.

**Linters to configure:**
- `python`: `ruff` (replaces flake8; ruff acts as linter and formatter)
- `ruby`: `rubocop` (supplemental; ruby-lsp may already surface rubocop diagnostics via LSP — monitor for duplicates)
- `lua`: `luacheck` (optional — lua_ls covers most; include if you want extra strictness)

**Steps:**

1. Add `nvim-lint` with `linters_by_ft`:
   - `python` = `{ "ruff" }`
   - `ruby` = `{ "rubocop" }` (monitor for duplication with ruby-lsp)
   - `lua` = `{ "luacheck" }` (optional)
2. Add autocmd:
   ```lua
   vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
     callback = function() require("lint").try_lint() end,
   })
   ```
3. Remove remaining entries from `ale_linters`: `luacheck`, `flake8`, `rubocop`
4. If `ale_linters` is now empty and `ale_disable_lsp = 1`, ALE is doing nothing useful

**Rollback**: Disable nvim-lint, restore `ale_linters` entries.

**Validation:**
- [ ] Add a Python syntax/lint error → ruff diagnostic appears in sign column
- [ ] Add a Lua undefined-variable reference → lua_ls or luacheck diagnostic appears
- [ ] `:lua require("lint").linters_by_ft` shows expected linters
- [ ] No duplicate diagnostics (e.g., rubocop appearing twice)

---

### Phase 6 — Update Dependent Plugins and Commands

**Goal**: Update plugins that reference ALE and finalize configuration.  
**Files**: `development.lua`, `init.lua`  
**Risk**: Low. Isolated changes per component.

**Steps:**

1. **vista.vim**: Change `vista_default_executive = "ale"` → `"nvim_lsp"`
2. **lualine.nvim** (optional enhancement): Add LSP diagnostics component to `lualine_x`:
   ```lua
   { "diagnostics", sources = { "nvim_lsp" } }
   ```
3. **init.lua `DisableFixers`**: Verify the conform-based rewrite from Phase 4 is complete; remove the `ale_fix_on_save` reference
4. **init.lua `ALEToggleFixer`**: Remove the command entirely

**Rollback**: Revert each change individually.

**Validation:**
- [ ] `:Vista` opens and shows LSP symbols (not an error)
- [ ] lualine statusline shows diagnostic counts
- [ ] `:DisableFixers` disables conform format-on-save and whitespace stripping
- [ ] No remaining `ale_` references in config files (check with `grep -r "ale_" ~/.config/nvim/`)

---

### Phase 7 — Remove ALE Entirely

**Goal**: Delete ALE and all its configuration.  
**Files**: `development.lua`, `init.lua`  
**Risk**: Low if all prior phases verified for several days.

**Steps:**

1. Delete the entire `dense-analysis/ale` spec block from `development.lua`
2. Delete the `lsp_signature.nvim` spec block if not already removed in Phase 3
3. Remove any remaining `vim.g.ale_*` global variables
4. Run `:Lazy clean` to delete from disk
5. Run `:checkhealth` — verify no ALE entries and no errors
6. Run `grep -r "ale" ~/.config/nvim/` — verify no remaining references
7. Commit: `chore(nvim): phase 7 — remove ALE, migration complete`

**Rollback**: Restore ALE spec block; `lazy.nvim` will reinstall automatically.

**Validation:**
- [ ] `:Lazy` does not list ALE
- [ ] `:checkhealth` passes with no ALE-related sections
- [ ] Startup time equal or faster than baseline (check `/tmp/nvim.log`)
- [ ] `gd`, `gr`, `K`, `<Space>rn`, `<C-k>`, `<C-j>` all work
- [ ] Format-on-save works for Go, Python, Lua, Ruby
- [ ] Diagnostics appear for all configured languages

---

## Part 6 — Optional Plugins (Post-Migration)

Add these one at a time after Phase 7 is stable.

### Phase 8A — fidget.nvim

**Role**: Shows LSP `$/progress` messages (server indexing, loading) as a non-intrusive spinner in the bottom-right corner.

**Value**: HIGH. After removing ALE, there is no visual feedback when language servers are starting or indexing. Without fidget, Neovim appears to silently hang. fidget solves this with zero configuration.

**Overlap with built-ins**: None. Neovim has no built-in LSP progress UI.

**lazy.nvim spec:**
```lua
{
  "j-hui/fidget.nvim",
  version = "*",
  event = "LspAttach",
  opts = {},
}
```

**Rollback**: Comment out spec entry.

**Validation:**
- [ ] Open a Go or Python file; a spinner appears briefly in the corner as the server indexes
- [ ] `:Fidget history` shows past LSP progress events

---

### Phase 8B — trouble.nvim

**Role**: Replaces the plain quickfix/loclist UI with a styled, navigable panel for diagnostics, LSP references, document symbols, and more. Has fzf-lua integration (already installed).

**Value**: MEDIUM-HIGH. The diagnostics panel (`<leader>xx`) is genuinely superior to `:copen`. The fzf-lua source integration (`<ctrl-t>` to send results to trouble) adds value since fzf-lua is already in the stack.

**Overlap with built-ins**: `:copen` and `:lopen` are the built-in equivalents; trouble adds grouping by file, icons, tree views, and filtering.

**lazy.nvim spec:**
```lua
{
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = {},
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble: all diagnostics" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble: buffer diagnostics" },
    { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Trouble: document symbols" },
    { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "Trouble: LSP panel" },
    { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble: location list" },
    { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble: quickfix list" },
  },
}
```

**fzf-lua integration** (add to fzf-lua config in `general.lua`):
```lua
local config = require("fzf-lua.config")
local actions = require("trouble.sources.fzf").actions
config.defaults.actions.files["ctrl-t"] = actions.open
```

**Rollback**: Comment out spec entry and fzf-lua integration.

**Validation:**
- [ ] `<leader>xx` opens the trouble panel with workspace diagnostics
- [ ] `<leader>cs` shows document symbols tree
- [ ] In fzf-lua, `<ctrl-t>` opens results in a trouble window

---

### Phase 8C — lspsaga.nvim

**Role**: Replaces native LSP floating windows with styled, interactive UI for hover, peek-definition, code actions, rename, and a combined finder (references + definitions).

**Value**: MEDIUM. Lspsaga's `peek_definition` (view definition without jumping) and `finder` (combined references + definitions in one view) are unique and useful. The styled hover and rename UI are nice-to-have but not essential — native LSP covers them adequately.

**Overlap concerns**:
- `K` hover → lspsaga `hover_doc` (nicer, scrollable)
- `<Space>rn` rename → lspsaga `rename` (in-place input widget)
- Code actions → lspsaga `code_action` (menu-style picker)
- **trouble.nvim** already covers LSP references/definitions panel → lspsaga `finder` partially overlaps
- Historically has had API breaking changes; verify compatibility with current nvim-lspconfig version

**Dependencies**: nvim-treesitter (already installed), nvim-web-devicons (already installed as dependency)

**lazy.nvim spec:**
```lua
{
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  opts = {},
  config = function(_, opts)
    require("lspsaga").setup(opts)
    vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Lspsaga: hover doc" })
    vim.keymap.set("n", "<Space>rn", "<cmd>Lspsaga rename<CR>", { desc = "Lspsaga: rename" })
    vim.keymap.set("n", "<Space>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Lspsaga: code action" })
    vim.keymap.set("n", "gp", "<cmd>Lspsaga peek_definition<CR>", { desc = "Lspsaga: peek definition" })
    vim.keymap.set("n", "<Leader>sf", "<cmd>Lspsaga finder<CR>", { desc = "Lspsaga: finder (refs + defs)" })
  end,
}
```

**Rollback**: Comment out spec entry; restore `K`, `<Space>rn`, `<Space>ca` to `vim.lsp.buf.*` targets.

**Validation:**
- [ ] `K` opens a styled hover doc window (scrollable with `<C-f>`/`<C-b>`)
- [ ] `<Space>rn` opens lspsaga rename input
- [ ] `gp` shows definition inline without jumping
- [ ] `<Leader>sf` opens the finder panel

---

## Part 7 — Final Cleanup Checklist

After Phase 7 and all chosen 8x phases:

- [ ] `grep -r "ale" ~/.config/nvim/` returns no hits (except comments if any)
- [ ] `:checkhealth` passes with no errors or warnings
- [ ] `:Lazy` shows expected plugins, no ALE
- [ ] Startup time ≤ baseline (compare `/tmp/nvim.log` to pre-migration)
- [ ] All languages: hover, definition, references, rename work
- [ ] All languages: format-on-save works
- [ ] All languages: diagnostics appear
- [ ] Spell toggle keymaps (F6/F7/F8) still work
- [ ] `:Vista` shows LSP symbols
- [ ] Snippets expand via Tab in all filetypes

---

## Part 8 — Future Improvements (Post-Migration)

1. **LSP inlay hints**: Enable `vim.lsp.inlay_hint.enable(true)` globally. Supported by gopls, basedpyright, lua_ls, typescript-language-server. Zero-plugin feature.
2. **nvim-dap**: Already commented out in development.lua. With native LSP stable, DAP for Go (delve), Python (debugpy), and Ruby (debug gem) becomes viable.
3. **neotest**: Test runner integration. Works well alongside native LSP. Provides a structured test panel similar to what IDEs offer.
4. **snacks.nvim**: Folke's new multi-purpose plugin with improved picker, bufdelete, notifier. Could consolidate fzf-lua + alpha-nvim in the future.
5. **Diagnostic float keymap**: Add `<Leader>e` → `vim.diagnostic.open_float()` to see full diagnostic message under cursor inline.
6. **Ruby rubocop duplication**: After Phase 5, monitor whether ruby-lsp already surfaces rubocop diagnostics. If so, remove rubocop from nvim-lint to avoid duplicates.

---

*Generated: 2026-05-11. Config analyzed from `/Users/erikw/src/github.com/erikw/dotfiles/.config/nvim/`.*
