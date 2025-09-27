-- Spec doc: https://lazy.folke.io/spec
-- Modeline {{
-- vi: foldmarker={{,}} foldmethod=marker foldlevel=0
-- }}

return {
    -- General {{

    --{'mfussenegger/nvim-dap'}      -- Debug Adapter Protocol client. Like LSP for debuggers. TODO try again when more mature. Currently LUA conf is not working (freezes nvim).
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


    -- AI powered code completion.
    --{
    --    "github/copilot.vim",
    --    init = function()
    --        -- Disable/enable per filetype
    --        vim.g.copilot_filetypes = {
    --            ["*"] = false, -- Setting to false disable for all types; can't be overriden.
    --            ["txt"] = false,
    --            ["markdown"] = false,
    --            ["sh"] = true,
    --            ["py"] = true,
    --            ["rb"] = true,
    --        }

    --        -- Remap from <tab> as this is used by snipmate.
    --        -- Ref: https://github.com/github/feedback/discussions/6919#discussioncomment-1553837
    --        vim.g.copilot_no_tab_map = 1
    --        vim.keymap.set(
    --            "i",
    --            "<C-Space>",
    --            'copilot#Accept("")',
    --            { silent = true, expr = true, desc = "Accept copilot suggestion." }
    --        )
    --    end,
    --   },

    {"andymass/vim-matchup"}, -- Extend % matching.
    {"rhysd/conflict-marker.vim"}, -- Navigate and edit VCS conflicts. Navigate: [x, ]x. Resolve: ct, co, cb.
    {"ruanyl/vim-gh-line"}, -- Copy link to file on GitHub.
    {"wellle/targets.vim"}, -- Extra text objects to operate on e.g. function arguments.

    -- TODO replace with built-in vim.snippet?
    -- Snippets engine compatible with the SnipMate format.
    {
        "dcampos/nvim-snippy",
        dependencies = { "honza/vim-snippets" }, -- snippet library
        opts = {
            mappings = {
                is = {
                    ["<Tab>"] = "expand_or_advance",
                    ["<S-Tab>"] = "previous",
                },
            },
        },
    },


    -- Git wrapper and shorthands.
    {
        "tpope/vim-fugitive",
        init = function()
            vim.keymap.set("n", "gb", ":Git blame<CR>", { silent = true, desc = "Git blame" })
        end,
    },



    -- Shift function arguments left and right.
    {
        "AndrewRadev/sideways.vim",
        init = function()
            vim.keymap.set("n", "<a", ":SidewaysLeft<CR>", { silent = true, desc = "Move function argument to the left." })
            vim.keymap.set("n", ">a", ":SidewaysRight<CR>", { silent = true, desc = "Move function argument to the right." })
        end,
    },


    -- Git modified status in sign column
    {
        "airblade/vim-gitgutter",
        config = function()
            vim.opt.updatetime = 100 -- Speedier update of file status.
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

    -- Highlight usage of method arguments.
    {
        "m-demare/hlargs.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        -- Due to a bug when dark-notify is enabled, do the hlargs init is done in the  dark-notify callback.
        -- Ref: https://github.com/m-demare/hlargs.nvim/issues/37#issuecomment-1237395420
	--opts = {}
    },

    -- Toggle values like true/false with <Leader>i.
    {
        "nguyenvukhang/nvim-toggler",
        opts = {},
    },

    -- Show code coverage in sign column.
    {
        "andythigpen/nvim-coverage",
        dependencies = "nvim-lua/plenary.nvim",
        opts = {},
    },

    -- Better than fugitive ':Git difftool'. Browser file history with ':DiffviewFileHistory %'
    {
        "sindrets/diffview.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        opts = {
                --hg_cmd = nil, # Not working to disable to get rid of :checkhealth warning, https://github.com/sindrets/diffview.nvim/issues/319
            },
        config = function()
            vim.api.nvim_create_user_command("Gdiff", ":DiffviewFileHistory %", { force = true, desc = "View diff file history of current buffer." })
        end,
    },

    -- NVim interface for tree-sitter (language parser).
    {
        "nvim-treesitter/nvim-treesitter",
	branch = 'main',
	pin = true,  -- Lazy won’t report it as needing an update
	lazy = false,
	build = ":TSUpdate",
        opts = {
                -- A list of parser names, or "all". Install manually with :TSINstall <parser>
                -- comment - for parsing e.g. TODO markers in comments.
                ensure_installed = { "comment", "lua", "vim", "ruby", "python", "javascript", "markdown" },

                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,

                -- Automatically install missing parsers when entering buffer
                auto_install = true,
                highlight = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },
            },
    },

    -- Open related file like test.
    {
        "rgroli/other.nvim",
        opts = {
                -- Show menu each time for multiple other files.
                rememberBuffers = false,
                showMissingFiles = false,
                keybindings = {
                    x = "open_file_sp()", -- Align with other plugin common binding for horizontral split. Default here is 's'.
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
        config = function()
            vim.api.nvim_set_keymap("n", "<leader>ll", "<cmd>:Other<CR>", { noremap = true, silent = true, desc = "Other: open" })
            vim.api.nvim_set_keymap("n", "<leader>lx", "<cmd>:OtherSplit<CR>", { noremap = true, silent = true, desc = "Other: open in split" })
            vim.api.nvim_set_keymap("n", "<leader>lv", "<cmd>:OtherVSplit<CR>", { noremap = true, silent = true, desc = "Other: open in vsplit" })
            --vim.api.nvim_set_keymap("n", "<leader>lc", "<cmd>:OtherClear<CR>", { noremap = true, silent = true, desc = "Other: clear saved other selections." })

            -- Context specific bindings
            vim.api.nvim_set_keymap("n", "<leader>lt", "<cmd>:OtherVSplit test<CR>", { noremap = true, silent = true })
        end,
    },

    -- Manage vim Sessions per git branch.
    {
        "superDross/ticket.vim",
        init = function()
            vim.g.auto_ticket = 0 -- Automatically load tickets when starting vim without file arguments.
        end,
        config = function()
            -- Alternatives that also support per-branch saving to some extent:
            -- * https://piet.me/branch-based-sessions-in-vim/
            -- * https://github.com/dhruvasagar/vim-prosession
            -- * https://github.com/wting/gitsessions.vim
            -- * https://github.com/rmagatti/auto-session


            -- Save current session.
            vim.keymap.set("n", "<C-M-s>", ':execute ":SaveSession" <bar> echo "Session saved"<CR>', { silent = true, desc = "Save current tickets.vim session." })
            vim.keymap.set("n", "<C-M-o>", ':execute ":OpenSession" <bar> echo "Session loaded"<CR>', { silent = true, desc = "Open saved tickets.vim session." })
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
    --{'neovim/nvim-lspconfig'}      -- Plug-n-play configurations for LSP server. Disabled in favour of simpler to use ALE.


    -- LSP linting engine.
    -- TODO replace with:
    -- * Native LSP (vim.lsp.*) → diagnostics, hover, definitions, completion, formatting
    -- * nvim-cmp → richer completion UI & sources (optional, but very common)
    -- * nvim-lint or null-ls.nvim → to integrate non-LSP linters/formatters into the diagnostics/code-action pipeline
    {
        "dense-analysis/ale",
        event = { "BufReadPre", "BufNewFile" },
        init = function()
            vim.g.ale_completion_enabled = 1 -- Must be set before ALE is loaded.
        end,
        config = function()
            -- Reference https://github.com/dense-analysis/ale/blob/master/doc/ale.txt

            -- ALE's LSP client clashes with built-in one and gives error on startup: Cannot serialise boolean: table key must be a number or string
            -- Ref: https://github.com/dense-analysis/ale/issues/4956
            --vim.g.ale_disable_lsp = 1
            vim.g.ale_use_neovim_lsp_api = 0

            -- gopls seems to work properly only when the source is in $GOPATH in a module?
            -- Disabled linters:
            -- ['sql'] = {'sqls'},
            vim.g.ale_linters = {
                ["go"] = { "gopls" },
                ["javascript"] = { "eslint" },
                ["lua"] = { "luacheck" },
                ["json"] = { "jsonls" },
                ["python"] = { "pyright", "flake8" },
                ["ruby"] = { "solargraph", "ruby" },
                ["sh"] = { "language_server" },
                ["tex"] = { "texlab" },
                ["vim"] = { "vimls" },
            }
            -- XDG path seems to be used for Linux but not macOS, until fixed https://github.com/mpeterv/luacheck/issues/231
            vim.g.ale_lua_luacheck_options = "--config $XDG_CONFIG_HOME/luacheck/.luacheckr"

            -- gopls seems to work properly only when the source is in $GOPATH in a module?
            -- Disabled fixers:
            -- - *: 'trim_whitespace' & 'remove_trailing_lines' (overlaps with the functionally already provided by vim-better-whitespace)
            -- - python: autoimport - (messes up ifx in taiga_stats.commands import  fix. Could be resolved by https://github.com/myint/autoflake/issues/59)
            -- - python: autoflake - too disruptive e.g. removing `from pprint import pprint` on write if it's unused.
            -- - markdown: prettier (converts * to - in lists)
            vim.g.ale_fixers = {
                ["css"] = { "prettier" },
                ["javascript"] = { "prettier", "eslint" },
                ["json"] = { "prettier" },
                ["go"] = { "gopls", "goimports" },
                ["lua"] = { "stylua" },
                ["python"] = { "black", "isort" },
                ["ruby"] = { "rubocop" },
                ["scss"] = { "prettier" },
                ["typescript"] = { "prettier" },
                ["yaml"] = { "prettier" },
            }

            vim.g.ale_fix_on_save = 1
            -- Let stylua find $XDG_CONFIG_HOME/stylua/stylua.toml
            vim.g.ale_lua_stylua_options = "--search-parent-directories"

            vim.g.ale_pattern_options = {
                ["Brewfile*"] = { ale_fixers = {} }, -- Disable all (ruby) fixers as I want my Brewfile indented in a particular way for folding and text operation on indentation (sorting).
            }

            -- Completion {
            vim.g.ale_completion_autoimport = 1
            -- Trigger on ^x^o
            vim.opt.omnifunc = "ale#completion#OmniFunc"
            -- 'longest' seems to tirgger a variation of :h ale-completion-completeopt-bug
            -- See https://github.com/dense-analysis/ale/issues/1700#issuecomment-991643960
            vim.opt.completeopt = { "menu", "preview" }
            -- }

            -- Mappings {
            -- See :help ale-commands
            -- Make similar keybindings to https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
            vim.keymap.set("n", "gd", "<Plug>(ale_go_to_definition)", { silent = true, desc = "ALE: go to definition." })
            vim.keymap.set("n", "gr", "<Plug>(ale_find_references)", { silent = true, desc = "ALE: find references." })
            vim.keymap.set("n", "K", "<Plug>(ale_hover)", { silent = true, desc = "ALE: hover." })
            vim.keymap.set("n", "<Space>rn", "<Plug>(ale_rename)", { silent = true, desc = "ALE: rename." })
            vim.keymap.set("n", "<Leader>I", "<Plug>(ale_import)", { silent = true, desc = "ALE: import." })

            -- Navigate between errors
            vim.keymap.set("n", "<C-k>", "<Plug>(ale_previous_wrap)", { silent = true, desc = "ALE: navigate to previous error." })
            vim.keymap.set("n", "<C-j>", "<Plug>(ale_next_wrap)", { silent = true, desc = "ALE: navigate to next error." })
            -- }

            -- Toggle command for fixers
            -- Ref: https://github.com/dense-analysis/ale/issues/1353#issuecomment-424677810
            vim.api.nvim_create_user_command(
                "ALEToggleFixer",
                "execute \"let g:ale_fix_on_save = get(g:, 'ale_fix_on_save', 0) ? 0 : 1\"",
                { force = true, desc = "ALE: toggle ale_fix_on_save" }
            )
        end,
    },

    -- Method signature window, as ALE does not support it. Ref: https://www.reddit.com/r/vim/comments/jhqzsv/signature_help_via_ale/
    {
        "ray-x/lsp_signature.nvim",
        opts = {
                toggle_key = "<M-x>", -- toggle signature on and off in insert mode
                select_signature_key = "<M-n>", -- cycle to next signature
            },
    },

    -- LSP symbols and tags viewer, like TagBar but with LSP support.
    {
        "liuchengxu/vista.vim",
        init = function()
            vim.g.vista_default_executive = "ale" -- Default executive.
            vim.g.vista_sidebar_width = 50 -- Window width.
        end,
        config = function()
            vim.keymap.set("n", "<F3>", ":Vista!! <CR>", { silent = true, desc = "Toggle Vista tag sidewindow." })
        end,
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
    --{'fatih/vim-go', ft = { 'go' }},   -- Compilation commands etc.
    --{ "sebdah/vim-delve", ft = { "go" }}, -- Debugger.
    -- }}

    -- Development: Java {{
    --{'erikw/jcommenter.vim', ft = { 'java' } },    -- Generate javadoc.
    -- }}

    -- Development: LaTeX {{
    --{'donRaphaco/neotex', ft = { 'tex' }},  -- Live preview PDF output from latex.
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
