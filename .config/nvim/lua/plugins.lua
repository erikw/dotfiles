-- Erik Westrup's Neovim plugin configuration.
-- init: ~/.config/nvim/init.lua
-- Modeline {{
-- vi: foldmarker={{,}} foldmethod=marker foldlevel=0
-- }}

-- packer.nvim Bootstrap {{
-- Bootstrapping of packer.nvim. Ref: https://github.com/wbthomason/packer.nvim#bootstrapping
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end
local packer_bootstrap = ensure_packer()
-- }}

return require("packer").startup(function(use)
    -- General {{
    --use('dhruvasagar/vim-table-mode')      -- Create ASCII tables
    --use('fidian/hexmode')            -- Open binary files as a HEX dump with :Hexmode
    --use('godlygeek/tabular')          -- Create tables. Disabled: not used and have some startup time.
    --use('voldikss/vim-translator')      -- Async language translator.

    -- Show matching keybindings e.g. when tapping Leader.
    --use({
    --    "folke/which-key.nvim",
    --    config = function()
    --        require("which-key").setup()
    --    end,
    --})

    use("danro/rename.vim") -- Provides the :Rename command
    use("michaeljsmith/vim-indent-object") -- Operate on intendtation as text objects.
    use("tpope/vim-capslock") -- Software CAPSLOCK with <C-g>c in insert mode.
    use("tpope/vim-characterize") -- 'ga' on steroid.
    use("tpope/vim-repeat") -- Extend '.' repetition for plugins like vim-surround, vim-speeddating, vim-unimpaired.
    use("tpope/vim-speeddating") -- Increment dates with C-a.
    use("tpope/vim-unimpaired") -- Bracket mappings like [<space>
    use("wbthomason/packer.nvim")

    -- Open URLs in buffer.
    use({
        "axieax/urlview.nvim",
        config = function()
            require("urlview").setup()
            vim.keymap.set("n", "\\u", "<Cmd>UrlView<CR>", { desc = "view buffer URLs" })
        end,
    })

    -- Register viewer and selector.
    use({
        "gennaro-tedesco/nvim-peekup",
        config = function()
            -- Paste selection to register ", so that it can be pasted directly with 'p'.
            -- Ref: https://github.com/gennaro-tedesco/nvim-peekup/issues/27
            require("nvim-peekup.config").on_keystroke["paste_reg"] = '"'
        end,
    })

    use({
        "instant-markdown/vim-instant-markdown",
        ft = "markdown",
        run = "yarn install",
        config = function()
            vim.g.instant_markdown_autostart = 1

            -- Blocklist certain paths for previewing files (recursively).
            -- See https://github.com/instant-markdown/vim-instant-markdown/issues/198
            -- [1-9]*.md - PR body by gh(1) have file names with this pattern.
            local augroup_imark = vim.api.nvim_create_augroup("InstantMarkdownGroup", { clear = true })
            vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile", "BufEnter", "BufFilePre" }, {
                pattern = "*/src/github.com/erikw/hackerrank-solutions/*.md,*/src/github.com/erikw/leetcode-solutions/*.md,[1-9]*.md",
                group = augroup_imark,
                command = "let g:instant_markdown_autostart=0",
            })
        end,
    })

    -- File explorer tree
    use({
        "nvim-tree/nvim-tree.lua",
        requires = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup({
                open_on_tab = true,
                filters = { custom = { "^.git$" } },
                view = {
                    width = "15%",
                    side = "left",
                },
            })

            -- When open_on_tab=true, syncs toggle globally acoss tabs.
            vim.keymap.set("n", "<F2>", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle file explorer tree." })
        end,
    })

    -- Work on surrond delimiters or its content. Like tpope/vim-surround but with TreeSitter.
    use({
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup()
        end,
    })

    -- Navigate history in a sidebar. Replaces old 'mbbill/undotree'
    use({
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<F4>", ":UndotreeToggle<CR>", { silent = true, desc = "Toggle Undotree side pane." })
            vim.g.undotree_WindowLayout = 2 -- Set style to have diff window below.
            vim.g.undotree_SetFocusWhenToggle = 1 -- Put cursor in undo window on open.
        end,
    })

    -- Highlight and remove trailing whitespaces.
    use({
        "ntpeters/vim-better-whitespace",
        config = function()
            vim.g.strip_whitelines_at_eof = 1 -- Also strip empty lines at end of file on save.
            vim.g.show_spaces_that_precede_tabs = 1 -- Highlight spaces that happens before tab.
            vim.g.strip_whitespace_on_save = 1 -- Activate by default.
            vim.g.strip_whitespace_confirm = 0 -- Don't ask for permission.

            -- Filetypes to ignore even when strip_whitespace_on_save=1
            --vim.g.better_whitespace_filetypes_blacklist = ['<filetype1>', '<filetype2>', '<etc>']

            vim.api.nvim_create_user_command("Ws", ":execute 'StripWhitespace' | update", { force = true, desc = ":w with StripWhitespace." })
            vim.api.nvim_create_user_command("Wqs", ":execute 'StripWhitespace' | wq", { force = true, desc = ":wq with StripWhitespace." })
            vim.api.nvim_create_user_command("Wqas", ":execute 'bufdo StripWhitespace' | wqa", { force = true, desc = ":wqa with StripWhitespace." })
        end,
    })

    use({
        "phaazon/hop.nvim",
        config = function()
            require("hop").setup()
            -- Keybindings
            -- Vim Command to Lua function mapping: https://github.com/phaazon/hop.nvim/wiki/Advanced-Hop#lua-equivalents-of-hop-commands
            vim.api.nvim_set_keymap("", "<leader>h", "<cmd>lua require'hop'.hint_words()<cr>", {})
        end,
    }) -- Easy motion jumps in buffer.

    -- Comment source code.
    use({
        "preservim/nerdcommenter",
        config = function()
            -- Align line-wise comment delimiters flush left instead of following code indentation
            vim.g.NERDDefaultAlign = "left"
        end,
    })
    -- }}

    -- Development {{
    -- Development: General {{
    --use('mfussenegger/nvim-dap')      -- Debug Adapter Protocol client. Like LSP for debuggers. TODO try again when more mature. Currently LUA conf is not working (freezes nvim).

    -- AI powered code completion.
    --use({
    --    "github/copilot.vim",
    --    config = function()
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
    --        vim.keymap.set(
    --            "i",
    --            "<C-Space>",
    --            'copilot#Accept("")',
    --            { silent = true, expr = true, desc = "Accept copilot suggestion." }
    --        )
    --        vim.g.copilot_no_tab_map = 1
    --    end,
    --})

    -- Indent vertical markers.
    --use({
    --    "lukas-reineke/indent-blankline.nvim",
    --    config = function()
    --        require("indent_blankline").setup({
    --            use_treesitter = true, -- use treesitter to calculate indentation.
    --            show_current_context = true, -- highlight current indent block.
    --            show_current_context_start = true, -- underline first line of current indent block.
    --        })
    --    end,
    --})

    use("andymass/vim-matchup") -- Extend % matching.
    use("editorconfig/editorconfig-vim") -- Standard .editorconfig file in shared projects.
    use("rhysd/conflict-marker.vim") -- Navigate and edit VCS conflicts. Navigate: [x, ]x. Resolve: ct, co, cb.
    use("ruanyl/vim-gh-line") -- Copy link to file on GitHub.
    use("wellle/targets.vim") -- Extra text objects to operate on e.g. function arguments.

    -- Git wrapper and shorthands.
    use({
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "gb", ":Git blame<CR>", { silent = true, desc = "Git blame" })
        end,
    })

    -- Shift function arguments left and right.
    use({
        "AndrewRadev/sideways.vim",
        config = function()
            vim.keymap.set("n", "<a", ":SidewaysLeft<CR>", { silent = true, desc = "Move function argument to the left." })
            vim.keymap.set("n", ">a", ":SidewaysRight<CR>", { silent = true, desc = "Move function argument to the right." })
        end,
    })

    -- Git modified status in sign column
    use({
        "airblade/vim-gitgutter",
        config = function()
            vim.opt.updatetime = 100 -- Speedier update of file status.
        end,
    })

    -- Markdown utilties like automatic list indention, TOC.
    use({
        "preservim/vim-markdown",
        ft = "markdown",
        branch = "master", -- Otherwise loading on ft=markdown does not work. Ref: https://github.com/preservim/vim-markdown#installation
        requires = { "godlygeek/tabular" },
        config = function()
            vim.g.vim_markdown_folding_disabled = 1 -- No fold by default
            vim.g.vim_markdown_toc_autofit = 1 -- Make :Toc smaller
            vim.g.vim_markdown_follow_anchor = 1 -- Let ge follow #anchors
            vim.g.vim_markdown_new_list_item_indent = 2 -- Bullent space indents.
            vim.keymap.set("n", "<Leader>3", ":Toc<CR>", { silent = true, desc = "Open markdown TOC in a quickfix window." })
        end,
    })

    -- Highlight usage of method arguments.
    use({
        "m-demare/hlargs.nvim",
        requires = { "nvim-treesitter/nvim-treesitter" },
        --config = function()
        --    -- Due to a bug when dark-notify is enabled, do the hlargs init is done in the  dark-notify callback.
        --    -- Ref: https://github.com/m-demare/hlargs.nvim/issues/37#issuecomment-1237395420
        --    require("hlargs").setup()
        --end,
    })

    -- Toggle values like true/false with <Leader>i.
    use({
        "nguyenvukhang/nvim-toggler",
        config = function()
            require("nvim-toggler").setup()
        end,
    })

    -- Show code coverage in sign column.
    use({
        "andythigpen/nvim-coverage",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("coverage").setup()
        end,
    })

    -- Better than fugitive ':Git difftool'. Browser file history with ':DiffviewFileHistory %'
    use({
        "sindrets/diffview.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("diffview").setup()
            vim.api.nvim_create_user_command("Gdiff", ":DiffviewFileHistory %", { force = true, desc = "View diff file history of current buffer." })
        end,
    })

    -- NVim interface for tree-sitter (language parser).
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
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
            })
        end,
    })

    -- Open related file like test.
    use({
        "rgroli/other.nvim",
        config = function()
            require("other-nvim").setup({
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
            })

            vim.api.nvim_set_keymap("n", "<leader>ll", "<cmd>:Other<CR>", { noremap = true, silent = true, desc = "Other: open" })
            vim.api.nvim_set_keymap("n", "<leader>lx", "<cmd>:OtherSplit<CR>", { noremap = true, silent = true, desc = "Other: open in split" })
            vim.api.nvim_set_keymap("n", "<leader>lv", "<cmd>:OtherVSplit<CR>", { noremap = true, silent = true, desc = "Other: open in vsplit" })
            --vim.api.nvim_set_keymap("n", "<leader>lc", "<cmd>:OtherClear<CR>", { noremap = true, silent = true, desc = "Other: clear saved other selections." })

            -- Context specific bindings
            vim.api.nvim_set_keymap("n", "<leader>lt", "<cmd>:OtherVSplit test<CR>", { noremap = true, silent = true })
        end,
    })

    -- Manage vim Sessions per git branch.
    use({
        "superDross/ticket.vim",
        config = function()
            -- Alternatives that also support per-branch saving to some extent:
            -- * https://piet.me/branch-based-sessions-in-vim/
            -- * https://github.com/dhruvasagar/vim-prosession
            -- * https://github.com/wting/gitsessions.vim
            -- * https://github.com/rmagatti/auto-session

            vim.g.auto_ticket = 0 -- Automatically load tickets when starting vim without file arguments.

            -- Save current session.
            vim.keymap.set("n", "<C-M-s>", ':execute ":SaveSession" <bar> echo "Session saved"<CR>', { silent = true, desc = "Save current tickets.vim session." })
            vim.keymap.set("n", "<C-M-o>", ':execute ":OpenSession" <bar> echo "Session loaded"<CR>', { silent = true, desc = "Open saved tickets.vim session." })
        end,
    })

    -- Autoclose brackets etc.
    use({
        "windwp/nvim-autopairs",
        config = function()
            local npairs = require("nvim-autopairs")
            npairs.setup({
                check_ts = true, --  Use treesitter to check for a pair
                map_c_h = true, -- Map the <C-h> key to delete a pair
                map_c_w = true, -- map <c-w> to delete a pair if possible
            })

            -- Ref: https://github.com/windwp/nvim-autopairs/wiki/Endwise
            -- Could use https://github.com/RRethy/nvim-treesitter-endwise instead
            npairs.add_rules(require("nvim-autopairs.rules.endwise-lua"))
            npairs.add_rules(require("nvim-autopairs.rules.endwise-ruby"))
        end,
    })
    -- }}

    -- Development: LSP/Completion {{
    --use('neovim/nvim-lspconfig')      -- Plug-n-play configurations for LSP server. Disabled in favour of simpler to use ALE.
    --

    -- LSP linting engine.
    use({
        "dense-analysis/ale",
        setup = function()
            vim.g.ale_completion_enabled = 1 -- Must be set before ALE is loaded.
        end,
        config = function()
            -- Reference https://github.com/dense-analysis/ale/blob/master/doc/ale.txt
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
            -- - python: autoimport (messes up ifx in taiga_stats.commands import  fix. Could be resolved by https://github.com/myint/autoflake/issues/59)
            -- - markdown: prettier (converts * to - in lists)
            vim.g.ale_fixers = {
                ["css"] = { "prettier" },
                ["javascript"] = { "prettier", "eslint" },
                ["json"] = { "prettier" },
                ["go"] = { "gopls", "goimports" },
                ["lua"] = { "stylua" },
                ["python"] = { "autoflake", "black", "isort" },
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
    })

    -- Method signature window, as ALE does not support it. Ref: https://www.reddit.com/r/vim/comments/jhqzsv/signature_help_via_ale/
    use({
        "ray-x/lsp_signature.nvim",
        config = function()
            require("lsp_signature").setup({
                toggle_key = "<M-x>", -- toggle signature on and off in insert mode
                select_signature_key = "<M-n>", -- cycle to next signature
            })
        end,
    })

    -- LSP symbols and tags viewer, like TagBar but with LSP support.
    use({
        "liuchengxu/vista.vim",
        config = function()
            vim.keymap.set("n", "<F3>", ":Vista!! <CR>", { silent = true, desc = "Toggle Vista tag sidewindow." })
            vim.g.vista_default_executive = "ale" -- Default executive.
            vim.g.vista_sidebar_width = 50 -- Window width.
        end,
    })
    -- }}

    -- Development: DAP {{
    --use('mfussenegger/nvim-dap') -- Debug Adapter Protocol
    --use('rcarriga/nvim-dap-ui')  -- UI for DAP
    --use('suketa/nvim-dap-ruby')  -- Config for ruby. Requries the `debug` gem. No rails support yet: https://github.com/suketa/nvim-dap-ruby/issues/25
    -- }}

    -- Development: C/C++ {{
    use("ludovicchabant/vim-gutentags") -- Autogenerate new tags file.
    -- }}

    -- Development: Go {{
    --use{'fatih/vim-go', ft = { 'go' } }  -- Compilation commands etc.
    use({ "sebdah/vim-delve", ft = { "go" } }) -- Debugger.
    -- }}

    -- Development: Java {{
    --use{'erikw/jcommenter.vim', ft = { 'java' } }    -- Generate javadoc.
    -- }}

    -- Development: LaTeX {{
    --use{'donRaphaco/neotex', ft = { 'tex' }  -- Live preview PDF output from latex.
    -- }}

    -- Development: Python {{
    --use{'python-rope/ropevim', ft = { 'python' } }  -- Refactoring with rope library.
    --use{'fisadev/vim-isort', ft = { 'python' } }      -- Sort imports
    -- }}

    -- Development: Swift {{
    --use{'keith/swift.vim', ft = { 'switft' } }      -- Syntax files for Switch
    -- }}

    -- Development: Web {{
    use({ "ap/vim-css-color", ft = { "css", "scss" } }) -- Display CSS colors.
    -- }}
    -- }}

    -- Navigation {{
    -- * Keyboard shortcuts: https://github.com/junegunn/fzf/blob/master/README-VIM.md#fzf
    -- * Commands: https://github.com/junegunn/fzf.vim#commands
    use({
        "junegunn/fzf.vim",
        requires = { "junegunn/fzf", run = ":call fzf#install()" },
        config = function()
            -- Stolen from my friend https://github.com/erikagnvall/dotfiles/blob/master/vim/init.vim
            -- Comment must be on line of its own...
            -- Search for files in given path.
            vim.keymap.set("n", "<Leader>f", ":FZF<space>", { silent = true, desc = "FZF: search for files in given path." })
            -- Sublime-like shortcut 'go to file' ctrl+p.
            vim.keymap.set("n", "<C-p>", ":Files<CR>", { silent = true, desc = "FZF: search for files starting at current directory." })
            vim.keymap.set("n", "<Leader>c", ":Commands<CR>", { silent = true, desc = "FZF: search commands." })
            vim.keymap.set("n", "<Leader>T", ":Tags<CR>", { silent = true, desc = "FZF: search in tags file" })
            vim.keymap.set("n", "<Leader>b", ":Buffers<CR>", { silent = true, desc = "FZF: search open buffers." })
            -- Ref: https://medium.com/@paulodiovani/vim-buffers-windows-and-tabs-an-overview-8e2a57c57afa).
            vim.keymap.set("n", "<Leader>t", ":Windows<CR>", { silent = true, desc = "FZF: search open tabs." })
            vim.keymap.set("n", "<Leader>H", ":History<CR>", { silent = true, desc = "FZF: search history of opended files" })
            vim.keymap.set("n", "<Leader>m", ":Maps<CR>", { silent = true, desc = "FZF: search mappings." })
            vim.keymap.set("n", "<Leader>g", ":Rg<CR>", { silent = true, desc = "FZF: search with rg (aka live grep)." })

            -- To ignore a certain path in a git project from both RG and FD used by FZF,
            -- the eaiest way is to create ignore files and exclude the in local git clone.
            -- Ref: https://stackoverflow.com/a/1753078/265508
            -- $ cd git_proj/
            -- $ echo "path/to/exclude" > .rgignore
            -- $ echo "path/to/exclude" > .fdignore
            -- $ printf ".rgignore\n.fdignore" >> .git/info/exclude
        end,
    })
    -- }}

    -- Snippets {{
    -- Snippets engine compatible with the SnipMate format.
    use({
        "dcampos/nvim-snippy",
        config = function()
            require("snippy").setup({
                mappings = {
                    is = {
                        ["<Tab>"] = "expand_or_advance",
                        ["<S-Tab>"] = "previous",
                    },
                },
            })
        end,
    })

    use("honza/vim-snippets") -- Snippet library
    -- }}

    -- Syntax {{
    use({ "bfontaine/Brewfile.vim", ft = { "brewfile" } }) -- Syntax for Brewfiles
    use({ "kalekundert/vim-nestedtext", ft = { "nestedtext" } }) -- Syntax for NestedText .nt files.
    -- }}

    -- UI {{
    --use('yamatsum/nvim-/ursorline')    -- Highlight current word under cursor. Not compatible with dark-notify: https://github.com/cormacrelf/dark-notify/issues/8
    --use('sitiom/nvim-numbertoggle')    -- Automatic relative / static line number toggling. Disabled as of https://github.com/sitiom/nvim-numbertoggle/issues/15

    -- Highlight current word under cursor. Not compatible with dark-notify: https://github.com/cormacrelf/dark-notify/issues/8
    --use({
    --    "RRethy/vim-illuminate",
    --    config = function()
    --        require("illuminate").configure()
    --    end,
    --})

    -- Visualize marks in the sign column.
    use({
        "chentoast/marks.nvim",
        config = function()
            require("marks").setup({})
        end,
    })

    -- Watch system light/dark mode changes. Requires dark-notify(1).
    use({
        "cormacrelf/dark-notify",
        config = function()
            require("dark_notify").run({
                onchange = function()
                    -- Init hlargs.nvim.
                    -- Ref: https://github.com/m-demare/hlargs.nvim/issues/37#issuecomment-1237395420
                    -- Ref: https://github.com/cormacrelf/dark-notify/issues/8
                    --require("hlargs").setup()
                end,
            })
            vim.keymap.set("n", "<F5>", ":lua require('dark_notify').toggle()<CR>", { silent = true, desc = "Toggle dark/light mode." })
        end,
    })

    -- More informative tab titles.
    use({
        "crispgm/nvim-tabline",
        requires = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("tabline").setup({})
        end,
    })

    -- Smoth scrolling.
    use({
        "karb94/neoscroll.nvim",
        config = function()
            require("neoscroll").setup()
        end,
    })

    -- The fastest greeter plugin.
    use({
        "goolord/alpha-nvim",
        requires = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local startify = require("alpha.themes.startify")

            -- Add bookmarks buttons. Ref: https://github.com/goolord/alpha-nvim/issues/14
            startify.section.bottom_buttons.val = {
                -- Preserving the button from https://github.com/goolord/alpha-nvim/blob/dafa11a6218c2296df044e00f88d9187222ba6b0/lua/alpha/themes/startify.lua#LL208C13-L208C47
                startify.button("q", "Quit", "<cmd>q <CR>"),

                startify.file_button(vim.fn.stdpath("config") .. "/init.lua", "v"),
                startify.file_button(vim.fn.stdpath("config") .. "/lua/plugins.lua", "p"),
                startify.file_button(vim.g.xdg_config_home .. "/shell/commons", "c"),
                startify.file_button(vim.g.xdg_config_home .. "/shell/aliases", "a"),
                startify.file_button(vim.g.xdg_config_home .. "/homebrew/Brewfile", "b"),
                startify.file_button(vim.g.xdg_config_home .. "/homebrew/Brewfile.cypress", "bc"),
            }
            require("alpha").setup(startify.config)
        end,
    })

    -- Statusline.
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
        config = function()
            require("lualine").setup({
                sections = {
                    lualine_c = {
                        {
                            "filename",
                            path = 1, -- relative path
                        },
                    },
                },
                inactive_sections = {
                    lualine_c = {
                        {
                            "filename",
                            path = 1, -- relative path
                        },
                    },
                },
                extensions = { "fugitive", "fzf", "nvim-tree", "quickfix" },
            })
        end,
    })

    -- Colorschemes {{
    --use('folke/tokyonight.nvim')
    --use('mhartington/oceanic-next')
    --use('morhetz/gruvbox')
    use("ishan9299/nvim-solarized-lua") -- Solarized theme that works with nvim-treesitter highlights.
    -- }}
    -- }}

    -- packer.nvim Automations {{
    -- Auto set up conf after cloning packer.nvim. Must be after the use():es.
    -- Ref: https://github.com/wbthomason/packer.nvim#bootstrapping
    if packer_bootstrap then
        require("packer").sync()
    end

    -- Auto-compile Packer for lazy-loading each time this file is changed.
    -- Ref: https://github.com/wbthomason/packer.nvim#quickstart
    local augroup_packer = vim.api.nvim_create_augroup("packer_user_config", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        pattern = "plugins.lua",
        group = augroup_packer,
        command = "source <afile> | PackerCompile",
    })
    -- }}
end)
