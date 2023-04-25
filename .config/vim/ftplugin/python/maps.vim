" Generate ctags with python site packages
map <F10> :!ctags -R -f ./tags `python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())"`<CR>

" Rope-vim mapping. Remapping from .vimrc does not work for some reason.
" Remap from default <C-c>ri
nmap <silent> <C-c>rI :RopeInline<CR>
" Auto import symbol under cursor.
nmap <silent> <C-c>ri :call RopeAutoImport()<CR>
