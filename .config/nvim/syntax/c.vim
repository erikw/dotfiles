" Extend /usr/share/vim/vim*/syntax/c.vim's syntax group.

"syntax keyword cTodo contained NOTE NOPE

let s:xdg_config_home = empty($XDG_CONFIG_HOME) ? "$HOME/.config" : $XDG_CONFIG_HOME
exec "source " . s:xdg_config_home . "/nvim/syntax/my_todo.vim"
call ExtendTodoSyntaxWithCustom('cTodo')
