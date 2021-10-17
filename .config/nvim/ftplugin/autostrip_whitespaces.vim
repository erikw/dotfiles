" Automatically strip whitespaces when writing buffer to file.

" Using ~/.vim/plugin/stripspaces.vim
"autocmd BufWritePost <buffer> :StripWhitespaces

" Using vim-better-whitespace plugin
autocmd BufWritePost <buffer> :StripWhitespace
