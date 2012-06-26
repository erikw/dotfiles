" Toggle the last used tab.
" Source: https://stackoverflow.com/a/2120168/265508
let g:lasttab = 1
nmap <C-^> :execute "tabnext ".g:lasttab<CR>
autocmd TabLeave * let g:lasttab = tabpagenr()
