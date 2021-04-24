" Extend /usr/share/vim/vim*/syntax/c.vim's syntax group.

"syntax keyword cTodo contained NOTE NOPE

source ~/.vim/syntax/my_todo.vim
call ExtendTodoSyntaxWithCustom('cTodo')
