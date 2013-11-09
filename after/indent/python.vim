"
" Python indentation extras
" Use in conjunction with ~/.vim/indent/python.vim from
" http://www.vim.org/scripts/script.php?script_id=974

" Put this script into ~/.vim/after/indent/python.vim
"
" Examples/test cases                                               {{{1
"
" Situation:                                                            {{{2
"
"       >>> some_func(foo,
"
"   press <CR>bar, you should get
"
"       >>> some_func(foo,
"       ...           bar
"
" Situation:                                                            {{{2
"
"       >>> some_func(
"
"   press <CR>bar, you should get
"
"       >>> some_func(
"       ...     bar
"
" Situation:                                                            {{{2
"
"       >>> some_func()
"
"   press <CR>bar, you should get
"
"       >>> some_func()
"       >>> bar
"
" Situation:                                                            {{{2
"
"       >>> some_func(foo,
"       ...           bar,
"
"   press <CR>baz, you should get
"
"       >>> some_func(foo,
"       ...           bar,
"       ...           baz
"
"   but if that's too hard, I'll settle for
"
"       >>> some_func(foo,
"       ...           bar,
"       ... baz
"
" Situation:                                                            {{{2
"
"       >>> some_func(foo,
"       ...           bar)
"
"   press <CR>baz, you should get
"
"       >>> some_func(foo,
"       ...           bar)
"       >>> baz
"
"  but since that's too hard and I get
"
"       >>> some_func(foo,
"       ...           bar)
"       ... baz
"
"  I'll settle for typing <CR>>>> bar instead to get
"
"       >>> some_func(foo,
"       ...           bar)
"       >>> baz
"
" Situation:                                                            {{{2
"
"       >>> some_func(foo, some, very, long, argument, list, bar)
"
"   press gq, you should get
"
"       >>> some_func(foo, some, very, long, argument, list
"       ...           bar)
"
"   with the cursor on the first letter of 'bar'
"
" Situation:                                                            {{{2
"
"       >>> some_list = [
"       ...     SomeClass(foo,
"
"   press <CR>bar, you should get
"
"       >>> some_list = [
"       ...     SomeClass(foo,
"       ...               bar
"
" Situation:                                                            {{{2
"
"       >>> some_func(foo,
"       ...           bar)
"
"   press J while on the first line, get
"
"       >>> some_func(foo, bar)
"
"   with the cursor positioned just in front of 'bar'
"
" }}}1

if !exists('g:py_doctest_fixups')
    let g:py_doctest_fixups = 1
endif
if !exists('g:py_doctest_mappings')
    let g:py_doctest_mappings = 1
endif

setlocal comments+=n:.

fun! FixDoctestIndent(adjust)                                       " {{{
    if !g:py_doctest_fixups
        return ''
    endif
    let line = getline('.')
    let prev_line = getline(line('.') - 1)
    if line =~ '^\s*\(>>>\|[.][.][.]\)' && prev_line =~ '^\s*\(>>>\|[.][.][.]\)'
        let cur_indent = matchstr(line, '^\s*')
        let prev_indent = matchstr(prev_line, '^\s*')
        if cur_indent != prev_indent
            let remainder = strpart(cur_indent, len(prev_indent) + 4)
            let max_extra_spaces_to_eat = max([1, len(prev_indent) - len(cur_indent) + 1])
            if &verbose >= 1
                echo "Indent: " . len(cur_indent)
                            \ . ", prev: " . len(prev_indent)
                            \ . ", remainder: " . len(remainder)
                            \ . ", spaces to eat: " . max_extra_spaces_to_eat
            endif
            if a:adjust
                if prev_line =~ '[({\[]$'
                    let remainder = remainder . '    '
                else
                    call cursor(line("."), col(".") - 4)
                endif
            else
                if len(prev_indent) < len(cur_indent)
                    let remainder = remainder . '    '
                endif
            endif
            if a:adjust
                let prefix = '...'
            else
                let prefix = matchstr(line, '^\s*\zs\(>>>\|[.][.][.]\)')
            endif
            call setline(".", substitute(line, '^\s*\(>>>\|[.][.][.]\)\s\{,'.max_extra_spaces_to_eat.'}', prev_indent . prefix . ' ' . remainder, ''))
        endif
    endif
    return ''
endf                                                                " }}}

fun! FixDoctestPrefix()                                             " {{{
    if !g:py_doctest_fixups
        return ''
    endif
    let line = getline('.')
    if line =~ '^\s*[.][.][.]\s*>>>'
        call cursor(line("."), col(".") - 4)
        call setline(".", substitute(line, '^\s*\zs[.][.][.]\s*', '', ''))
    endif
    return ''
endf                                                                " }}}

fun! FixDoctestJoin()                                               " {{{
    if !g:py_doctest_fixups
        return ''
    endif
    let c = col(".")
    exec 's/\%' . c . 'c\s*[.][.][.]\s\+/ /e'
    call cursor(line("."), c)
    return ''
endf                                                                " }}}

if g:py_doctest_mappings
    nnoremap <silent> <buffer> o o<C-R>=FixDoctestIndent(1)<CR>
    nnoremap <silent> <buffer> O O<C-R>=FixDoctestIndent(1)<CR>
    nnoremap <silent> <buffer> gqq gqq:call FixDoctestIndent(1)<CR>
    nnoremap <silent> <buffer> gqh gqh:call FixDoctestIndent(1)<CR>
    nnoremap <silent> <buffer> gql gql:call FixDoctestIndent(1)<CR>
    nnoremap <silent> <buffer> gq<Left> gq<Left>:call FixDoctestIndent(1)<CR>
    nnoremap <silent> <buffer> gq<Right> gq<Right>:call FixDoctestIndent(1)<CR>
    nnoremap <silent> <buffer> J J:call FixDoctestJoin()<CR>
    inoremap <silent> <buffer> <CR> <CR><C-R>=FixDoctestIndent(1)<CR>
    inoremap <silent> <buffer> <C-T> <C-T><C-R>=FixDoctestIndent(0)<CR>
    inoremap <silent> <buffer> <C-D> <C-D><C-R>=FixDoctestIndent(0)<CR>
    inoremap <silent> <buffer> > ><C-R>=FixDoctestPrefix()<CR>
endif
