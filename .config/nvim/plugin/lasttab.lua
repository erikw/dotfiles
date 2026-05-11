-- Toggle the last used tab.
-- Source: https://stackoverflow.com/a/2120168/265508
vim.g.lasttab = 1

-- <C-^> is intentionally left free for its built-in alternate-buffer function.
vim.keymap.set("n", "<Leader><Tab>", function()
    vim.cmd("tabnext " .. vim.g.lasttab)
end, { silent = true, desc = "Switch to last used tab." })

vim.api.nvim_create_autocmd("TabLeave", {
    callback = function()
        vim.g.lasttab = vim.fn.tabpagenr()
    end,
})
