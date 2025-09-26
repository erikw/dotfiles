return {

	--{ "dhruvasagar/vim-table-mode"},-- Create ASCII tables
	--{ "fidian/hexmode"},		-- Open binary files as a HEX dump with :Hexmode
	--{ "godlygeek/tabular"},		-- Create tables. Disabled: not used and have some startup time.
	--{ "voldikss/vim-translator"},	-- Async language translator.
  { "danro/rename.vim" },		-- Provides the :Rename command


  {"danro/rename.vim"}, -- Provides the :Rename command
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
    }
}
