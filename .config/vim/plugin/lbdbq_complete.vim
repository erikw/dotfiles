" TODO use this instead? https://github.com/vim-scripts/lbdbq
" Name: lbdbq_complete.vim
" Summary: Complete ldbq-queries with ^x^u.
" URL: http://dollyfish.net.nz/blog/2008-04-01/mutt-and-vim-custom-autocompletion
" Version: 0.1

" If mutt_mode is on: use lbdb query completion.
if exists('mutt_mode')
    ino <C-n> <C-X><C-U>
    ino <C-p> <C-X><C-U>

    fun! LBDBCompleteFn(findstart, base)
        if a:findstart
            " locate the start of the word
            let line = getline('.')
            let start = col('.') - 1
            while start > 0 && line[start - 1] =~ '[^:,]'
              let start -= 1
            endwhile
            while start < col('.') && line[start] =~ '[:, ]'
                let start += 1
            endwhile
            return start
        else
            let res = []
            let query = substitute(a:base, '"', '', 'g')
            let query = substitute(query, '\s*<.*>\s*', '', 'g')
            for m in LbdbQuery(query)
                call add(res, printf('"%s" <%s>', escape(m[0], '"'), m[1]))
            endfor
            return res
        endif
    endfun

    set completefunc=LBDBCompleteFn
endif
