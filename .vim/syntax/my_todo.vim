let s:myTODOKWs = 'NOTE NOPE'

" Set my TODO keyword to a given syntax group, from
" /usr/share/vim/vim*/syntax/*.vim
" for example cTodo, javaTodo
function! ExtendTodoSyntaxWithCustom(syntaxgroup)
	exec "syntax keyword " . a:syntaxgroup . " contained " . s:myTODOKWs
endfunction
