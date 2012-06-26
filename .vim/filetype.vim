" Syntax highlighting for tmux.conf.
augroup filetypedetect
	au BufNewFile,BufRead .tmux.conf*,tmux.conf* setf tmux
augroup END
