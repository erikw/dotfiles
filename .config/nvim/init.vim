" Erik Westrup's Neovim configuration.
" Modeline {
"	vi: foldmarker={,} foldmethod=marker foldlevel=0 tabstop=4 :
" }

" Profiling {
" $ nvim --startuptime /tmp/nvim.log
" $ nvim --startuptime /dev/stdout +qall
" Reference: https://stackoverflow.com/questions/1687799/profiling-vim-startup-time
" }

" TODO migrate Vundle plugins, to a plugin manager. vim-plug? https://github.com/junegunn/vim-plug
" TODO fix indentation of comments to be consistent in this file.


" Environment {
set tags+=./tags;/	" Look for tags in current directory or search up until found.

" Also use $HOME/.vim in Windows. TODO needed?
"if has('win32') || has('win64')
"	set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
"endif
" }

" General {
set undofile				" Save undo to file in undodir.
set mouse=a					" Enable mouse in all modes.

"set spell					" Enable spell highlighting and suggestions.
set spelllang=en_us				" Languages to do spell checking for.
set spellsuggest=best,10			" Limit spell suggestions.
" Set spellfile dynamically. Shared with Vim.
execute "set spellfile=" . "~/.vim/spell/" . matchstr(&spelllang, "[a-zA-Z][a-zA-Z]") . "." . &encoding . ".add"
" TODO make this depend on 'spellang' if I can get files for Swedish and German.
set thesaurus+=~/.vim/thesaurus/mthesaur.txt    " Use a thesaurus file.
set completeopt=longest,menu,preview		" Insert most common completion and show menu.

set omnifunc=syntaxcomplete#Complete		" Let Omni completion (^x^o) use vim's builtin syntax files for language keywords.
" TODO ALE not needed as neovim has native LSP? https://neovim.io/doc/lsp/
"set omnifunc=ale#completion#OmniFunc		" Use ALE for omnicompletion

set shortmess=filmnrxtToOI    			" Abbreviate messages.
set nrformats=alpha,bin,octal,hex			" What to increment/decrement with ^A and ^X.
set hidden						" Work with hidden buffers more easily. Enables to leave buffer with unwritten changes (by :edit another buffer).
set sessionoptions-=options		" Don't store global and local variables when saving sessions.
set undolevels=2048				" Levels of undo to keep in memory.
"set clipboard+=unnamed				" Use register "* instead of unnamed register. This means what is being yanked in vim gets put to external clipboard automatically.
set timeoutlen=1500				" Timout (ms) for mappings and keycodes.
" }



