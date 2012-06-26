" Return the current OS: {linux,mac,win}.
" Source: " http://unix.stackexchange.com/questions/40047/vim-script-check-running-platform
function! GetRunningOS()
  	if has("win32")
    		return "win"
  	endif
  	if has("unix")
    		if system('uname')=~'Darwin'
      			return "mac"
    		else
      			return "linux"
    		endif
  	endif
endfunction
