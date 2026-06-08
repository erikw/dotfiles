-- Spec doc: https://lazy.folke.io/spec
-- Modeline {{
-- vi: foldmarker={{,}} foldmethod=marker foldlevel=0
-- }}

return {

    --{ "dhruvasagar/vim-table-mode"},-- Create ASCII tables
    --{ "fidian/hexmode"},		-- Open binary files as a HEX dump with :Hexmode
    --{ "godlygeek/tabular"},		-- Create tables. Disabled: not used and have some startup time.
    --{ "voldikss/vim-translator"},	-- Async language translator.

    -- Show matching keybindings e.g. when tapping Leader.
    --{
    --    "folke/which-key.nvim",
    --    opts = {}
    --},

    { "danro/rename.vim", cmd = "Rename" }, -- Provides the :Rename command
    { "michaeljsmith/vim-indent-object", event = "BufReadPre" }, -- Operate on intendtation as text objects.
    { "tpope/vim-capslock", event = "InsertEnter" }, -- Software CAPSLOCK with <C-g>c in insert mode.
    { "tpope/vim-characterize", keys = { "ga" } }, -- 'ga' on steroid.
    { "tpope/vim-repeat", event = "BufReadPre" }, -- Extend '.' repetition for plugins like vim-surround, vim-speeddating, vim-unimpaired.
    { "tpope/vim-speeddating", event = "BufReadPre" }, -- Increment dates with C-a.
    { "tpope/vim-unimpaired", event = "BufReadPre" }, -- Bracket mappings like [<space>

    -- Open URLs in buffer.
    {
        "axieax/urlview.nvim",
        cmd = "UrlView",
        opts = {},
        init = function()
            vim.keymap.set("n", "\\u", "<Cmd>UrlView<CR>", { desc = "view buffer URLs" })
        end,
    },

    -- Register viewer and selector.
    {
        "gennaro-tedesco/nvim-peekup",
        event = "BufReadPre",
        opts = {},
        config = function()
            -- Paste selection to register ", so that it can be pasted directly with 'p'.
            -- Ref: https://github.com/gennaro-tedesco/nvim-peekup/issues/27
            require("nvim-peekup.config").on_keystroke["paste_reg"] = '"'
        end,
    },

    {
        "instant-markdown/vim-instant-markdown",
        ft = "markdown",
        build = "yarn install",
        init = function()
            vim.g.instant_markdown_autostart = 1

            -- Blocklist certain paths for previewing files (recursively).
            -- See https://github.com/instant-markdown/vim-instant-markdown/issues/198
            -- [1-9]*.md - PR body by gh(1) have file names with this pattern.
            local augroup_imark = vim.api.nvim_create_augroup("InstantMarkdownGroup", { clear = true })
            vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile", "BufEnter", "BufFilePre" }, {
                pattern = "*/src/github.com/erikw/hackerrank-solutions/*.md,*/src/github.com/erikw/leetcode-solutions/*.md,[1-9]*.md",
                group = augroup_imark,
                callback = function()
                    vim.g.instant_markdown_autostart = 0
                end,
            })
        end,
    },

    -- File explorer tree
    -- Keybindings: https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<F2>", ":NvimTreeToggle<CR>", silent = true, desc = "Toggle file explorer tree." },
        },
        opts = {
            filters = { custom = { "^.git$" } },
            view = {
                width = "15%",
                side = "left",
            },
        },
        --init = function()
        -- When open_on_tab=true, syncs toggle globally acoss tabs.
        --vim.keymap.set("n", "<F2>", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle file explorer tree." })
        --end,
    },

    -- Work on surrond delimiters or its content. Like tpope/vim-surround but with TreeSitter.
    {
        "kylechui/nvim-surround",
        event = "BufReadPre",
        opts = {},
    },

    -- Highlight and remove trailing whitespaces.
    {
        "ntpeters/vim-better-whitespace",
        event = { "BufReadPre", "BufNewFile" }, -- lazy-load on file open
        init = function()
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
    },

    -- Easy motion jumps in buffer. Replaces archived hop.nvim.
    -- Docs: https://github.com/folke/flash.nvim
    -- Default keys: s (jump), S (treesitter), r (remote/operator), R (treesitter remote), <C-s> (toggle in search).
    -- {
    --     "folke/flash.nvim",
    --     event = "VeryLazy",
    --     opts = {},
    --     keys = {
    --         { "s",     function() require("flash").jump() end,              mode = { "n", "x", "o" }, desc = "Flash: jump" },
    --         { "S",     function() require("flash").treesitter() end,        mode = { "n", "x", "o" }, desc = "Flash: treesitter jump" },
    --         { "r",     function() require("flash").remote() end,            mode = "o",               desc = "Flash: remote (operator)" },
    --         { "R",     function() require("flash").treesitter_search() end, mode = { "o", "x" },      desc = "Flash: treesitter search" },
    --         { "<C-s>", function() require("flash").toggle() end,            mode = "c",               desc = "Flash: toggle in search" },
    --     },
    -- },

    -- Keyboard shortcuts: https://github.com/junegunn/fzf/blob/master/README-VIM.md#fzf
    -- Commands: https://github.com/junegunn/fzf.vim#commands
    -- To ignore a certain path in a git project I can't change from both rg(1) and fd(1) used by FZF,
    -- the eaiest way is to create ignore files and exclude the in local git clone.
    -- Ref: https://stackoverflow.com/a/1753078/265508
    -- $ cd git_proj/
    -- $ echo "path/to/exclude" > .ignore
    -- $ echo ".ignore" >> .git/info/exclude
    --
    -- Replaced by fzf-lua
    --{
    --    "junegunn/fzf.vim",
    --    dependencies = {
    --        {
    --            "junegunn/fzf",
    --            build = ":call fzf#install()",
    --        },
    --    },
    --    keys = {
    --        { "<Leader>f", ":FZF<space>",    desc = "FZF: search for files in given path." },
    --        { "<C-p>",     ":Files<CR>",     desc = "FZF: search for files starting at current directory." },
    --        { "<Leader>c", ":Commands<CR>",  desc = "FZF: search commands." },
    --        { "<Leader>T", ":Tags<CR>",      desc = "FZF: search in tags file" },
    --        { "<Leader>b", ":Buffers<CR>",   desc = "FZF: search open buffers." },
    --        { "<Leader>t", ":Windows<CR>",   desc = "FZF: search open tabs." },
    --        { "<Leader>H", ":History<CR>",   desc = "FZF: search history of opened files" },
    --        { "<Leader>:", ":History:<CR>",  desc = "FZF: search history of commands" },
    --        { "<Leader>m", ":Maps<CR>",      desc = "FZF: search mappings." },
    --        { "<Leader>g", ":Rg<CR>",        desc = "FZF: search with rg (live grep)." },
    --    },
    --},

    -- Improved fzf
    -- Replaced fzf.vim:
    -- To ignore a certain path in a git project I can't change from both rg(1) and fd(1) used by FZF,
    -- the eaiest way is to create ignore files and exclude the in local git clone.
    -- Ref: https://stackoverflow.com/a/1753078/265508
    -- $ cd git_proj/
    -- $ echo "path/to/exclude" > .ignore
    -- $ echo ".ignore" >> .git/info/exclude
    {
        "ibhagwan/fzf-lua",
        dependencies = {
            {
                "junegunn/fzf",
                build = ":call fzf#install()",
            },
        },
        config = function()
            require("fzf-lua").setup({})
            -- trouble.nvim integration: <C-f> in any fzf-lua picker opens results in Trouble.
            local fzf_config = require("fzf-lua.config")
            local ok, trouble_fzf = pcall(require, "trouble.sources.fzf")
            if ok then
                fzf_config.defaults.actions.files["ctrl-f"] = trouble_fzf.actions.open
            end
        end,
        keys = {
            {
                "<Leader>f",
                function()
                    require("fzf-lua").files({ cwd = vim.fn.input("Dir: ", vim.fn.getcwd(), "dir") })
                end,
                desc = "fzf-lua: files in given path",
            },
            {
                "<C-p>",
                function()
                    require("fzf-lua").files()
                end,
                desc = "fzf-lua: files in cwd",
            },
            {
                "<Leader>c",
                function()
                    require("fzf-lua").commands()
                end,
                desc = "fzf-lua: commands",
            },
            {
                "<Leader>T",
                function()
                    require("fzf-lua").tags()
                end,
                desc = "fzf-lua: tags",
            },
            {
                "<Leader>b",
                function()
                    require("fzf-lua").buffers()
                end,
                desc = "fzf-lua: buffers",
            },
            {
                "<Leader>t",
                function()
                    require("fzf-lua").tabs()
                end,
                desc = "fzf-lua: tabs/windows",
            },
            {
                "<Leader>H",
                function()
                    require("fzf-lua").oldfiles()
                end,
                desc = "fzf-lua: file history",
            },
            {
                "<Leader>:",
                function()
                    require("fzf-lua").command_history()
                end,
                desc = "fzf-lua: command history",
            },
            {
                "<Leader>m",
                function()
                    require("fzf-lua").keymaps()
                end,
                desc = "fzf-lua: keymaps",
            },
            {
                "<Leader>g",
                function()
                    require("fzf-lua").live_grep()
                end,
                desc = "fzf-lua: live grep (rg)",
            },
        },
    },

    -- Generate Lorem Ipsum strings.
    {
        "derektata/lorem.nvim",
        config = function()
            require("lorem").opts({
                sentence_length = "mixed", -- using a default configuration
                comma_chance = 0.3, -- 30% chance to insert a comma
                max_commas = 2, -- maximum 2 commas per sentence
                debounce_ms = 200, -- default debounce time in milliseconds
            })
        end,
    },
}
