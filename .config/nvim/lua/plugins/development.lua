-- Spec doc: https://lazy.folke.io/spec
-- Modeline {{
-- vi: foldmarker={{,}} foldmethod=marker foldlevel=0
-- }}

return {
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
    }
}
