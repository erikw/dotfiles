-- Spec doc: https://lazy.folke.io/spec

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

  {"danro/rename.vim"},		-- Provides the :Rename command
  {"michaeljsmith/vim-indent-object"}, -- Operate on intendtation as text objects.
  {"tpope/vim-capslock"}, -- Software CAPSLOCK with <C-g>c in insert mode.
  {"tpope/vim-characterize"}, -- 'ga' on steroid.
  {"tpope/vim-repeat"}, -- Extend '.' repetition for plugins like vim-surround, vim-speeddating, vim-unimpaired.
  {"tpope/vim-speeddating"}, -- Increment dates with C-a.
  {"tpope/vim-unimpaired"}, -- Bracket mappings like [<space>
  {"wbthomason/packer.nvim"},


    -- Open URLs in buffer.
    {
        "axieax/urlview.nvim",
        opts = {},
        init = function()
            vim.keymap.set("n", "\\u", "<Cmd>UrlView<CR>", { desc = "view buffer URLs" })
        end,
    },

    -- Register viewer and selector.
    {
        "gennaro-tedesco/nvim-peekup",
        opts = { },
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
                command = "let g:instant_markdown_autostart=0",
            })
        end,
    },



    -- File explorer tree
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{"<F2>", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle file explorer tree." }}
	},
        opts = {
                open_on_tab = true,
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
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
	pin = true,  -- Lazy won’t report it as needing an update
        opts = {}
    },




    -- Navigate history in a sidebar. Replaces old 'mbbill/undotree'
    {
        "mbbill/undotree",
        keys = {"<F4>" },
        init = function()
            vim.g.undotree_WindowLayout = 2 -- Set style to have diff window below.
            vim.g.undotree_SetFocusWhenToggle = 1 -- Put cursor in undo window on open.
        end,
        config = function()
            vim.keymap.set("n", "<F4>", ":UndotreeToggle<CR>", { silent = true, desc = "Toggle Undotree side pane." })
        end,
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

    -- Easy motion jumps in buffer.
    {
	'smoka7/hop.nvim',
	version = "*",
	pin = true,  -- Lazy won’t report it as needing an update
	keys = { "<leader>h" },
	opts = { },
	init = function()
		-- Vim Command to Lua function mapping: https://github.com/phaazon/hop.nvim/wiki/Advanced-Hop#lua-equivalents-of-hop-commands
		vim.keymap.set("n", "<leader>h", function()
			require("hop").hint_words()
			end, { desc = "Hop to words in buffer" })
	end,
    },

    -- Comment source code.
    {
        "preservim/nerdcommenter",
        init = function()
            -- Align line-wise comment delimiters flush left instead of following code indentation
            vim.g.NERDDefaultAlign = "left"
        end,
    },

}
