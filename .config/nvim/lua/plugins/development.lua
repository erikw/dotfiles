-- Spec doc: https://lazy.folke.io/spec
-- Modeline {{
-- vi: foldmarker={{,}} foldmethod=marker foldlevel=0
-- }}

return {
    -- General {{

    --{'mfussenegger/nvim-dap'}      -- Debug Adapter Protocol client. Like LSP for debuggers. Try again when more mature. Currently LUA conf is not working (freezes nvim).
    --{"editorconfig/editorconfig-vim"}, -- Standard .editorconfig file in shared projects. No longer needed, is built-in since Nvim 0.9

    -- Indent vertical markers.
    --{
    --    "lukas-reineke/indent-blankline.nvim",
    --     opts = {
    --            use_treesitter = true, -- use treesitter to calculate indentation.
    --            show_current_context = true, -- highlight current indent block.
    --            show_current_context_start = true, -- underline first line of current indent block.
    --     },
    --},

    -- GitHub Copilot (official)
    --{
    --    "github/copilot.vim",
    --    event = "BufReadPost",
    --    init = function()
    --        -- Disable/enable per filetype
    --        vim.g.copilot_filetypes = {
    --            go = true,
    --            markdown = false,
    --            python = true,
    --            ruby = true,
    --            sh = true,
    --            text = false,
    --        }
    --        -- Remap from <tab> as this is used by snipmate.
    --        -- Ref: https://github.com/github/feedback/discussions/6919#discussioncomment-1553837
    --        vim.g.copilot_no_tab_map = 1
    --    end,

    --    config = function()
    --        -- Remap from <tab> as this is used by snipmate.
    --        vim.keymap.set("i", "<C-Space>", 'copilot#Accept("\\<CR>")', {
    --            silent = true,
    --            expr = true,
    --            replace_keycodes = false,
    --            desc = "Accept copilot suggestion.",
    --        })
    --    end,
    --},

    -- GitHub Copilot lua implementation (inofficial)
    --{
    --    "zbirenbaum/copilot.lua",
    --    dependencies = { "copilotlsp-nvim/copilot-lsp" },
    --    cmd = "Copilot",
    --    event = "InsertEnter",
    --    opts = {
    --        suggestion = {
    --            enabled = true,
    --            keymap = {
    --                accept = "<M-l>",
    --                accept_word = false,
    --                accept_line = false,
    --                next = "<M-]>",
    --                prev = "<M-[>",
    --                dismiss = "<C-]>",
    --            },
    --        },
    --        nes = {
    --            enabled = false,
    --        },
    --        filetypes = {
    --            --["*"] = false, -- disable for all other filetypes and ignore default `filetypes`
    --            go = true,
    --            markdown = false,
    --            python = true,
    --            ruby = true,
    --            sh = true,
    --            text = false,
    --        },
    --    },
    --},

    ---- GitHub Copilot Chat
    --{
    --    "CopilotC-Nvim/CopilotChat.nvim",
    --    dependencies = {
    --        { "nvim-lua/plenary.nvim", branch = "master" },
    --    },
    --    build = "make tiktoken",
    --    opts = {
    --        -- See Configuration section for options
    --    },
    --},

    -- Inofficial claude code extension
    --{
    --    "coder/claudecode.nvim",
    --    dependencies = { "folke/snacks.nvim" },
    --    config = true,
    --    keys = {
    --        { "<leader>a", nil, desc = "AI/Claude Code" },
    --        { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    --        { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    --        { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    --        { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    --        { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    --        { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    --        { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    --        {
    --            "<leader>as",
    --            "<cmd>ClaudeCodeTreeAdd<cr>",
    --            desc = "Add file",
    --            ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
    --        },
    --        -- Diff management
    --        { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    --        { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    --    },
    --},

    { "andymass/vim-matchup", event = "BufReadPre" }, -- Extend % matching.
    { "rhysd/conflict-marker.vim", event = "BufReadPre" }, -- Navigate and edit VCS conflicts. Navigate: [x, ]x. Resolve: ct, co, cb.
    { "ruanyl/vim-gh-line", event = "BufReadPre" }, -- Copy link to file on GitHub.
    { "wellle/targets.vim", event = "BufReadPre" }, -- Extra text objects to operate on e.g. function arguments.

    -- Replaced by L3MON4D3/LuaSnip
    --{
    --    "dcampos/nvim-snippy",
    --    event = "InsertEnter",
    --    dependencies = { "honza/vim-snippets" },
    --    opts = {
    --        mappings = {
    --            is = {
    --                ["<Tab>"] = "expand_or_advance",
    --                ["<S-Tab>"] = "previous",
    --            },
    --        },
    --    },
    --},

    -- Snippets engine. Replaces nvim-snippy.
    -- Custom snippets live in ~/.config/nvim/snippets/ (VSCode JSON format).
    -- friendly-snippets is loaded from rtp; custom snippets via explicit path.
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp", -- optional: enables regex-based triggers
        dependencies = { "rafamadriz/friendly-snippets" },
        -- No event trigger: blink.cmp depends on LuaSnip and is non-lazy, so LuaSnip
        -- loads at startup as a dependency. An InsertEnter event here is never the trigger.
        config = function()
            local luasnip = require("luasnip")

            -- filetype_extend must be called before lazy_load.
            -- Maps the "_" pseudo-filetype into the "all" scope so _global.json
            -- snippets are available in every buffer.
            luasnip.filetype_extend("all", { "_" })

            -- Load friendly-snippets from rtp (has its own package.json).
            require("luasnip.loaders.from_vscode").lazy_load()
            -- Load custom snippets from ~/.config/nvim/snippets/ (VSCode JSON format).
            require("luasnip.loaders.from_vscode").lazy_load({
                paths = { vim.fn.stdpath("config") .. "/snippets" },
            })

            -- <Tab>: expand trigger → jump forward → fall through to normal Tab.
            vim.keymap.set({ "i", "s" }, "<Tab>", function()
                if luasnip.expandable() then
                    luasnip.expand()
                elseif luasnip.locally_jumpable(1) then
                    luasnip.jump(1)
                else
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
                end
            end, { silent = true, desc = "LuaSnip: expand, jump forward, or Tab" })

            -- <S-Tab>: jump backward through tabstops.
            vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
                if luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                end
            end, { silent = true, desc = "LuaSnip: jump backward" })
        end,
    },

    -- Git wrapper and shorthands.
    {
        "tpope/vim-fugitive",
        cmd = { "Git" },
        init = function()
            vim.keymap.set("n", "gb", ":Git blame<CR>", { silent = true, desc = "Git blame" })
        end,
    },

    -- Shift function arguments left and right.
    {
        "AndrewRadev/sideways.vim",
        cmd = { "SidewaysLeft", "SidewaysRight" },
        init = function()
            vim.keymap.set("n", "<a", ":SidewaysLeft<CR>", { silent = true, desc = "Move function argument to the left." })
            vim.keymap.set("n", ">a", ":SidewaysRight<CR>", { silent = true, desc = "Move function argument to the right." })
        end,
    },

    -- Git modified status in sign column
    {
        "airblade/vim-gitgutter",
        event = "BufReadPre",
        config = function()
            vim.opt.updatetime = 250 -- Speedier update of gitgutter signs and CursorHold-based features.
        end,
    },

    -- Markdown utilties like automatic list indention, TOC.
    {
        "preservim/vim-markdown",
        ft = "markdown",
        branch = "master", -- Otherwise loading on ft=markdown does not work. Ref: https://github.com/preservim/vim-markdown#installation
        dependencies = { "godlygeek/tabular" },
        config = function()
            vim.g.vim_markdown_folding_disabled = 1 -- No fold by default
            vim.g.vim_markdown_toc_autofit = 1 -- Make :Toc smaller
            vim.g.vim_markdown_follow_anchor = 1 -- Let ge follow #anchors
            vim.g.vim_markdown_new_list_item_indent = 2 -- Bullent space indents.
            vim.keymap.set("n", "<Leader>3", ":Toc<CR>", { silent = true, desc = "Open markdown TOC in a quickfix window." })
        end,
    },

    -- Toggle values like true/false with <Leader>i.
    {
        "nguyenvukhang/nvim-toggler",
        keys = { "<leader>i" },
        opts = {},
    },

    -- Show code coverage in sign column.
    {
        "andythigpen/nvim-coverage",
        cmd = { "Coverage", "CoverageLoad", "CoverageShow", "CoverageHide", "CoverageToggle", "CoverageClear" },
        dependencies = "nvim-lua/plenary.nvim",
        opts = {},
    },

    -- Better than fugitive ':Git difftool'. Browser file history with ':DiffviewFileHistory %'
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose", "DiffviewToggleFiles" },
        dependencies = "nvim-lua/plenary.nvim",
        -- :Gdiff is created in init (always runs at startup) so it exists before the plugin loads.
        -- Calling :Gdiff runs DiffviewFileHistory which hits the cmd stub above and loads the plugin.
        init = function()
            vim.api.nvim_create_user_command("Gdiff", "DiffviewFileHistory %", { force = true, desc = "View diff file history of current buffer." })
        end,
        opts = {},
        config = function(_, opts)
            require("diffview").setup(opts)
        end,
    },

    -- NVim interface for tree-sitter (language parser).
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup({
                -- A list of parser names, or "all". Install manually with :TSInstall <parser>
                -- comment - for parsing e.g. TODO markers in comments.
                ensure_installed = { "comment", "lua", "vim", "ruby", "python", "javascript", "markdown" },
                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,
                -- Automatically install missing parsers when entering buffer
                auto_install = true,
            })
            -- The `main` branch no longer configures highlight/indent via setup().
            -- Enable treesitter-based highlighting for each buffer when a parser is available.
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
                callback = function(ev)
                    pcall(vim.treesitter.start, ev.buf)
                end,
            })
        end,
    },

    -- Open related file like test.
    {
        "rgroli/other.nvim",
        opts = {
            -- Show menu each time for multiple other files.
            rememberBuffers = false,
            showMissingFiles = false,
            keybindings = {
                x = "open_file_sp()", -- Align with other plugin common binding for horizontal split. Default here is 's'.
            },
            mappings = {
                -- builtin mappings
                "rails",
                "golang",
                -- custom mappings
            },
            style = {
                width = 0.7,
            },
        },
        config = function(_, opts)
            require("other-nvim").setup(opts)
            vim.keymap.set("n", "<leader>ll", "<cmd>Other<CR>", { silent = true, desc = "Other: open" })
            vim.keymap.set("n", "<leader>lx", "<cmd>OtherSplit<CR>", { silent = true, desc = "Other: open in split" })
            vim.keymap.set("n", "<leader>lv", "<cmd>OtherVSplit<CR>", { silent = true, desc = "Other: open in vsplit" })
            --vim.keymap.set("n", "<leader>lc", "<cmd>OtherClear<CR>", { silent = true, desc = "Other: clear saved other selections." })

            -- Context specific bindings
            vim.keymap.set("n", "<leader>lt", "<cmd>OtherVSplit test<CR>", { silent = true, desc = "Other: open related test" })
        end,
    },

    -- Manage vim Sessions per git branch.
    {
        "superDross/ticket.vim",
        cmd = { "SaveSession", "OpenSession" },
        keys = {
            { "<C-M-s>", ':execute ":SaveSession" <bar> echo "Session saved"<CR>', silent = true, desc = "Save current tickets.vim session." },
            { "<C-M-o>", ':execute ":OpenSession" <bar> echo "Session loaded"<CR>', silent = true, desc = "Open saved tickets.vim session." },
        },
        init = function()
            vim.g.auto_ticket = 0 -- Automatically load tickets when starting vim without file arguments.
        end,
    },

    -- Autoclose brackets etc.
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            check_ts = true, --  Use treesitter to check for a pair
            map_c_h = true, -- Map the <C-h> key to delete a pair
            map_c_w = true, -- map <c-w> to delete a pair if possible
        },
        --config = function()
        --    local npairs = require("nvim-autopairs")
        --    -- Ref: https://github.com/windwp/nvim-autopairs/wiki/Endwise
        --    -- Could use https://github.com/RRethy/nvim-treesitter-endwise instead
        --    npairs.add_rules(require("nvim-autopairs.rules.endwise-lua"))
        --    npairs.add_rules(require("nvim-autopairs.rules.endwise-ruby"))
        --end,
    },

    -- }}

    -- Development: LSP/Completion {{

    -- LSP Core: mason + nvim-lspconfig {{
    -- Uses the modern nvim-lspconfig v2 API (Neovim 0.11+):
    --   vim.lsp.config()  — per-server settings
    --   vim.lsp.enable()  — activate servers  (done automatically by mason-lspconfig)
    --   LspAttach autocmd — replaces the old on_attach callback

    -- Mason: LSP/tool installer.
    {
        "mason-org/mason.nvim",
        build = ":MasonUpdate",
        opts = { ui = { border = "rounded" } },
    },

    -- mason-tool-installer: idempotent auto-install for non-LSP tools (conform, nvim-lint).
    -- Replaces the manual registry.refresh() scan that ran on every startup.
    -- LSP servers are managed by mason-lspconfig below.
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = {
                "ruff",          -- Python formatter (conform) + linter (nvim-lint)
                "stylua",        -- Lua formatter (conform)
                "prettier",      -- JS/TS/CSS/SCSS/JSON/YAML formatter (conform)
                "goimports",     -- Go formatter (conform)
                "golangci-lint", -- Go linter (nvim-lint)
                "shfmt",         -- Bash/sh formatter (conform)
                "shellcheck",    -- Bash/sh linter; used internally by bashls
                "markdownlint",  -- Markdown linter (nvim-lint)
                -- rubocop intentionally omitted: mason's isolated gem env lacks
                -- project cops (rubocop-rails etc.) and conflicts with mise's
                -- rubocop --server daemon. Use mise-managed rubocop instead.
                "luacheck",      -- Lua linter (nvim-lint)
            },
            auto_update = false,
            run_on_start = true,
        },
    },

    -- mason-lspconfig v2: installs servers and calls vim.lsp.enable() for them.
    -- automatic_enable=true (default) means no manual vim.lsp.enable() calls needed.
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
        opts = {
            ensure_installed = {
                "gopls",        -- Go
                "eslint",       -- JavaScript / TypeScript
                "jsonls",       -- JSON
                "basedpyright", -- Python (replaces pyright)
                "ruby_lsp",     -- Ruby (replaces solargraph)
                "bashls",       -- Shell
                "texlab",       -- LaTeX
                "vimls",        -- Vimscript
                "lua_ls",       -- Lua
            },
            -- automatic_enable = true is the default: mason-lspconfig calls
            -- vim.lsp.enable() for every installed server automatically.
        },
    },

    -- nvim-lspconfig: provides the lsp/ server config files consumed by vim.lsp.config().
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            vim.diagnostic.config({
                signs = true,
                virtual_text = true,
                underline = true,
                update_in_insert = false,
            })

            -- Wire blink.cmp's extended capabilities (snippetSupport, resolveSupport, etc.)
            -- into every LSP server. Must run before any server starts.
            vim.lsp.config('*', {
                capabilities = require('blink.cmp').get_lsp_capabilities(),
            })

            -- lua_ls: override the nvim-lspconfig default to teach it about the
            -- Neovim runtime (vim.* globals, plugins in rtp).
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        workspace = {
                            checkThirdParty = false,
                            library = { vim.env.VIMRUNTIME },
                        },
                        telemetry = { enable = false },
                    },
                },
            })

            -- Enable inlay hints globally; Neovim only activates them for servers
            -- that advertise inlayHintProvider (gopls, basedpyright, lua_ls, etc.).
            vim.lsp.inlay_hint.enable(true)

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("NativeLspAttach", { clear = true }),
                callback = function(args)
                    local buf = args.buf
                    -- Default mappings: https://neovim.io/doc/user/lsp/#lsp-defaults
                    -- Neovim 0.10+ sets K (hover), grn (rename), gra (code_action), grr (references),
                    -- gri (implementation), [d/]d (diagnostic nav) automatically.
                    -- The mappings below use different keys matching prior muscle memory,
                    -- so they are set explicitly. K is omitted — it's already a built-in default.
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "LSP: go to definition" })
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = buf, desc = "LSP: find references" })
                    vim.keymap.set("n", "<Space>rn", vim.lsp.buf.rename, { buffer = buf, desc = "LSP: rename" })
                    vim.keymap.set("n", "<Leader>I", vim.lsp.buf.code_action, { buffer = buf, desc = "LSP: code action (import)" })
                    vim.keymap.set("n", "<Space>ca", vim.lsp.buf.code_action, { buffer = buf, desc = "LSP: code action" })
                    vim.keymap.set("n", "<C-k>", function() vim.diagnostic.goto_prev({ wrap = true }) end, { buffer = buf, desc = "LSP: previous diagnostic" })
                    vim.keymap.set("n", "<C-j>", function() vim.diagnostic.goto_next({ wrap = true }) end, { buffer = buf, desc = "LSP: next diagnostic" })
                end,
            })
        end,
    },

    -- LSP progress spinner in the bottom-right corner.
    -- Shows $/progress messages (server indexing, loading) so startup isn't silent.
    {
        "j-hui/fidget.nvim",
        version = "*",
        event = "LspAttach",
        opts = {},
    },
    -- }}

    -- Completion: blink.cmp {{
    -- Keep nvim-autopairs; blink.cmp auto_brackets disabled.
    -- LuaSnip integrated via snippets.preset = 'luasnip'.
    -- Signature help built-in.
    -- Capabilities are wired in nvim-lspconfig via vim.lsp.config('*', ...).
    -- Ref: https://cmp.saghen.dev/installation
    {
        "saghen/blink.cmp",
        version = "1.*", -- v2 is in development and may have breaking changes; switch to it when stable.
        -- LuaSnip is already installed; declaring it here wires blink.cmp's
        -- snippet expand/jump to LuaSnip's API (snippets.preset = 'luasnip').
        dependencies = { { "L3MON4D3/LuaSnip", version = "v2.*" } },
        opts = {
            -- 'default' preset: C-y accept, C-n/C-p navigate, C-e hide menu,
            -- C-k toggle signature help. No Tab binding — LuaSnip owns Tab/S-Tab.
            keymap = { preset = "default" },
            appearance = { nerd_font_variant = "mono" },
            -- Use LuaSnip for expanding LSP-provided snippets and showing
            -- LuaSnip snippets in the completion menu.
            snippets = { preset = "luasnip" },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            completion = {
                accept = {
                    -- Decision A: nvim-autopairs handles bracket insertion;
                    -- disable blink.cmp auto_brackets to avoid duplicates.
                    auto_brackets = { enabled = false },
                },
                documentation = { auto_show = true, auto_show_delay_ms = 500 },
            },
            -- Built-in signature help.
            signature = { enabled = true },
            fuzzy = { implementation = "prefer_rust_with_warning" },
        },
        opts_extend = { "sources.default" },
    },
    -- }}

    -- Formatting: conform.nvim {{
    -- format_on_save is a function so we can skip Brewfiles and respect
    -- vim.g.disable_autoformat (set by DisableFixers command in init.lua).
    -- Ref: https://github.com/stevearc/conform.nvim
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        ---@module "conform"
        ---@type conform.setupOpts
        opts = {
            formatters_by_ft = {
                css        = { "prettier" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                json       = { "prettier" },
                go         = { "goimports" }, -- gopls handles LSP-format separately
                lua        = { "stylua" },
                markdown   = { "prettier" },
                python     = { "ruff_format" }, -- replaces black + isort
                ruby       = { "rubocop" },
                scss       = { "prettier" },
                sh         = { "shfmt" },
                yaml       = { "prettier" },
            },
                -- format_on_save as function: skip Brewfiles
            -- and respect the global disable flag (used by DisableFixers).
            format_on_save = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                -- Brewfile: never format (no formatter appropriate for Brewfile syntax).
                if vim.bo[bufnr].filetype == "brewfile" then
                    return
                end
                return { timeout_ms = 2000, lsp_format = "fallback" }
            end,
        },
        config = function(_, opts)
            require("conform").setup(opts)
        end,
    },
    -- }}

    -- Linting: nvim-lint {{
    -- LSP diagnostics (errors, warnings) come from the language servers via nvim-lspconfig.
    -- nvim-lint adds supplemental linting for tools that are not language servers.
    -- Ref: https://github.com/mfussenegger/nvim-lint
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufWritePost" },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                go       = { "golangcilint" },  -- golangci-lint wraps staticcheck, errcheck, unused, etc.
                markdown = { "markdownlint" },  -- markdown style/structure linting
                python   = { "ruff" },          -- ruff covers flake8 + isort rules
               -- ruby     = { "rubocop" },     -- supplemental; monitor for duplicates with ruby-lsp LSP diagnostics
                lua      = { "luacheck" },       -- supplemental; lua_ls covers most, luacheck adds extra strictness
                -- sh: omitted — bashls already runs shellcheck internally; adding it here duplicates diagnostics
            }

            -- luacheck: point at XDG config.
            -- luacheck reads --config from its own arg, not $XDG_CONFIG_HOME automatically.
            local luacheck = lint.linters.luacheck
            luacheck.args = vim.list_extend(
                { "--config", (vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")) .. "/luacheck/.luacheckrc" },
                luacheck.args or {}
            )

            vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
                group = vim.api.nvim_create_augroup("NvimLint", { clear = true }),
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
    -- }}

    -- Diagnostics / quickfix panel (replaces plain :copen).
    -- Ref: https://github.com/folke/trouble.nvim
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        opts = {},
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                         desc = "Trouble: workspace diagnostics" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",            desc = "Trouble: buffer diagnostics" },
            { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",                 desc = "Trouble: document symbols" },
            { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "Trouble: LSP panel" },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                             desc = "Trouble: location list" },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                             desc = "Trouble: quickfix list" },
        },
    },

    -- LSP symbols and tags viewer (replaces Vista.vim which is unmaintained for Neovim 0.11+).
    -- Uses treesitter or LSP as backend; integrates with lualine for symbol breadcrumbs.
    {
        "stevearc/aerial.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", "nvim-treesitter/nvim-treesitter" },
        cmd = { "AerialToggle", "AerialOpen", "AerialNavToggle" },
        keys = {
            { "<F3>", "<cmd>AerialToggle!<CR>", silent = true, desc = "Toggle Aerial symbol sidebar." },
        },
        opts = {
            backends = { "treesitter", "lsp" },
            layout = {
                min_width = 50,
                max_width = 50,
                default_direction = "prefer_right",
            },
            show_guides = true,
            -- Extend beyond the narrow default to show variables, constants, etc.
            -- Full SymbolKind list: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#symbolKind
            filter_kind = {
                "Class",
                "Constant",
                "Constructor",
                "Enum",
                "EnumMember",
                "Field",
                "Function",
                "Interface",
                "Method",
                "Module",
                "Namespace",
                "Property",
                "Struct",
                "TypeParameter",
                "Variable",
            },
        },
    },

    -- }}

    -- Development: DAP {{
    --{'mfussenegger/nvim-dap'}, -- Debug Adapter Protocol
    --{'rcarriga/nvim-dap-ui'},  -- UI for DAP
    --{'suketa/nvim-dap-ruby'},  -- Config for ruby. Requries the `debug` gem. No rails support yet: https://github.com/suketa/nvim-dap-ruby/issues/25
    -- }}

    -- Development: C/C++ {{
    --{"ludovicchabant/vim-gutentags"}, -- Autogenerate new tags file.
    -- }}

    -- Development: Go {{
    --{'fatih/vim-go', ft = { 'go' } },   -- Compilation commands etc.
    --{ "sebdah/vim-delve", ft = { "go" } }, -- Debugger.
    -- }}

    -- Development: Java {{
    --{'erikw/jcommenter.vim', ft = { 'java' } },    -- Generate javadoc.
    -- }}

    -- Development: LaTeX {{
    --{'donRaphaco/neotex', ft = { 'tex' } },  -- Live preview PDF output from latex.
    -- }}

    -- Development: Python {{
    --{'python-rope/ropevim', ft = { 'python' } },  -- Refactoring with rope library.
    --{'fisadev/vim-isort', ft = { 'python' } },      -- Sort imports
    -- }}

    -- Development: Swift {{
    --{'keith/swift.vim', ft = { 'switft' } },      -- Syntax files for Switch
    -- }}

    -- Development: Web {{
    { "ap/vim-css-color", ft = { "css", "scss" } }, -- Display CSS colors.
    -- }}
}
