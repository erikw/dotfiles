" Extend /usr/share/vim/vim*/syntax/c.vim's syntax group.

"syntax keyword cTodo contained NOTE NOPE

source $XDG_CONFIG_HOME/nvim/syntax/my_todo.vim
call ExtendTodoSyntaxWithCustom('cTodo')
