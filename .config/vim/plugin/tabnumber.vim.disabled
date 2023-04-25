" Show tabnumbers in the tabbar. This is a merge of two scripts at http://vim.wikia.com/wiki/Show_tab_number_in_your_tab_line
" TODO replace with https://github.com/mkitt/tabline.vim when it works for gvim too https://github.com/mkitt/tabline.vim/issues/8

if has("gui_running")
	set showtabline=2 " always show tabs in gvim, but not vim
	" set up tab labels with tab number, buffer name, number of windows
	function! GuiTabLabel()
		let label = ''
		let bufnrlist = tabpagebuflist(v:lnum)
		" Add '+' if one of the buffers in the tab page is modified
		for bufnr in bufnrlist
			if getbufvar(bufnr, "&modified")
				let label = '+'
				break
			endif
		endfor
		" Append the tab number
		let label .= v:lnum.': '
		" Append the buffer name
		let name = bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
		if name == ''
			" give a name to no-name documents
			if &buftype=='quickfix'
				let name = '[Quickfix List]'
			else
				let name = '[No Name]'
			endif
		else
			" get only the file name
			let name = fnamemodify(name,":t")
		endif
		let label .= name
		" Append the number of windows in the tab page
		let wincount = tabpagewinnr(v:lnum, '$')
		return label . '  [' . wincount . ']'
	endfunction
	set guitablabel=%{GuiTabLabel()}
else
	set tabline=%!MyTabLine()
	function MyTabLine()
		let s = '' " complete tabline goes here
		" loop through each tab page
		for t in range(tabpagenr('$'))
			" select the highlighting for the buffer names
			if t + 1 == tabpagenr()
				let s .= '%#TabLineSel#'
			else
				let s .= '%#TabLine#'
			endif
			" empty space
			let s .= ' '
			" set the tab page number (for mouse clicks)
			let s .= '%' . (t + 1) . 'T'
			" set page number string
			let s .= t + 1 . ' '
			" get buffer names and statuses
			let n = ''  "temp string for buffer names while we loop and check buftype
			let m = 0 " &modified counter
			let bc = len(tabpagebuflist(t + 1))  "counter to avoid last ' '
			" loop through each buffer in a tab
			for b in tabpagebuflist(t + 1)
				" buffer types: quickfix gets a [Q], help gets [H]{base fname}
				" others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
				if getbufvar( b, "&buftype" ) == 'help'
					let n .= '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )
				elseif getbufvar( b, "&buftype" ) == 'quickfix'
					let n .= '[Q]'
				else
					let n .= pathshorten(bufname(b))
					"let n .= bufname(b)
				endif
				" check and ++ tab's &modified count
				if getbufvar( b, "&modified" )
					let m += 1
				endif
				" no final ' ' added...formatting looks better done later
				if bc > 1
					let n .= ' '
				endif
				let bc -= 1
			endfor
			" add modified label [n+] where n pages in tab are modified
			if m > 0
				"let s .= '[' . m . '+]'
				let s.= '+ '
			endif
			" add buffer names
			if n == ''
				let s .= '[No Name]'
			else
				let s .= n
			endif
			" switch to no underlining and add final space to buffer list
			"let s .= '%#TabLineSel#' . ' '
			let s .= ' '
		endfor
		" after the last tab fill with TabLineFill and reset tab page nr
		let s .= '%#TabLineFill#%T'
		" right-align the label to close the current tab page
		if tabpagenr('$') > 1
			let s .= '%=%#TabLine#%999XX'
		endif
		return s
	endfunction
endif
