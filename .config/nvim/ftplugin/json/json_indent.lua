-- Format JSON code.
-- Source: " http://stackoverflow.com/questions/16620835/how-to-fix-json-indentation-in-vim
vim.api.nvim_create_user_command('JSONFormat', '<line1>,<line2>!python -m json.tool', {force = true, range = true, nargs = 0, bar = true, desc = "Format JSON code."})
