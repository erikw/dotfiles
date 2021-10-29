" Automatically strip whitespaces when writing buffer to file.

" Using ~/.vim/plugin/stripspaces.vim
"autocmd BufWritePost <buffer> :StripWhitespaces

" Using vim-better-whitespace plugin
" NOTE replaced with let g:strip_whitespace_on_save=1 in main config file.
autocmd BufWritePost <buffer> :StripWhitespace
