-- Toggle the last used tab.
-- Source: https://stackoverflow.com/a/2120168/265508
vim.g.lasttab = 1

vim.keymap.set("n", "<C-^>", function()
    vim.cmd("tabnext " .. vim.g.lasttab)
end, { silent = true, desc = "Switch to last used tab." })

vim.api.nvim_create_autocmd("TabLeave", {
    callback = function()
        vim.g.lasttab = vim.fn.tabpagenr()
    end,
})
