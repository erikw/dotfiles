" tab-multi-diff.vim
" Version:       1
" Authors:       Laurence Gonsalves <laurence@xenomachina.com>
" Created:       2012-02-01
" Last Modified: 2012-02-01
" Instalation:   Place in plugin directory (typically ~/.vim/plugin/)
" License:       GPLv2 (http://www.gnu.org/licenses/gpl-2.0.html)
" URL:           https://github.com/xenomachina/public/tree/master/vim/plugin
"
" Adds some functions to vim to make it easier to use vim as a
" multi-tabbed diff tool.


" Creates a new tab page for each consecutive pair of buffers (split
" vertically, with first on left and second on right) and sets all of the
" new windows to diff mode. The original tab page will also be closed.
"
" Intended usage is to start vim with alternating "old" and "new" files,
" and then invoke this function. It expects there to be only one tab
" open and 2*n buffers.
"
" Example:
"   gvim -c 'silent call TabMultiDiff()' old-foo foo old-bar bar
"
"   This will result in two tabs: old-foo+foo diff, and old-bar+bar diff.
function! TabMultiDiff()
  let s:tab_multi_diff = 0
  argdo call s:AddBufferToTab()
  tabclose
endfun


" Convenience function for starting up with Vim top-level window
" "maximized" and all splits on all tabs set to always be "equal sized".
"
" Example:
"   gvim -c 'silent call TabMultiDiffMaximized()' old-foo foo old-bar bar
function! TabMultiDiffMaximized()
  augroup TabMultiDiffMaximize
    " I originally tried to just do this on VimEnter, but it didn't seem
    " to work. Having it trigger on every resize is actually kind of
    " nice, though, so I'm not unhappy with this workaround.
    autocmd VimResized * silent! call EquilizeAllTabWindows()
  augroup END
  " Cheesily, but pretty reliably, resizes vim to full screen.
  set lines=999 columns=999
  call TabMultiDiff()
endfun


" Makes all windows on all tabs equally high/wide, but stays on current
" tab.
function! EquilizeAllTabWindows()
  let orig = tabpagenr()
  tabdo wincmd =
  while tabpagenr() != orig
    tabprevious
  endwhile
endfun


" Helper function used by TabMultiDiff(). Adds current buffer to new tab
" or last tab as appropriate, and sets new window's "diff" option.
function! s:AddBufferToTab()
  let buf = bufnr("%")
  if s:tab_multi_diff
    tablast
    vsplit
    wincmd w
  else
    tab split
    tabmove
  endif
  let s:tab_multi_diff = ! s:tab_multi_diff
  exe 'b ' . buf
  diffthis
  tabfirst
endfun
