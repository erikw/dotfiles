" Extend vim-unimpaired with ]d and [d to delete above and below the current line.
" See https://github.com/tpope/vim-unimpaired/issues/157
" See https://gist.github.com/erikw/b2fa678f0e14e80bceda67582d46a688
"
" Installation: put this file in
" - vim: $HOME/.vim/plugin/
" - neovim: $XDG_CONFIG_HOME/nvim/plugin/

function! s:DeleteUp(count) abort
  normal! m`
  normal ix
  normal x
  if a:count > 1
    exe "normal k".eval(a:count-1)."dk"
  else
    exe "normal k".a:count."dd"
  endif
  norm! ``
  silent! call repeat#set("\<Plug>unimpairedDeleteUp", a:count)
endfunction

function! s:DeleteDown(count) abort
  normal! m`
  normal ix
  normal x
  if a:count > 1
    exe "normal j".eval(a:count-1)."dj"
  else
    exe "normal j".a:count."dd"
  endif
  norm! ``
  silent! call repeat#set("\<Plug>unimpairedDeleteDown", a:count)
endfunction

nnoremap <silent> <Plug>unimpairedDeleteUp   :<C-U>call <SID>DeleteUp(v:count1)<CR>
nnoremap <silent> <Plug>unimpairedDeleteDown :<C-U>call <SID>DeleteDown(v:count1)<CR>

nmap [d <Plug>unimpairedDeleteUp
nmap ]d <Plug>unimpairedDeleteDown


