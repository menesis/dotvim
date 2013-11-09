" Vim plugin for editing Bazaar (http://bazaar-vcs.org/) commit messages:
" shows a diff in a second window.
"
" Early version, probably doesn't work in all cases
"
" Based on svn.vim by Michael Scherer (misc@mandrake.org) and others.
"
" Place this file in ~/.vim/ftplugin/, and create a new file in ~/.vim/ftdetect,
" called bzr.vim, with the following line inside:
"   au BufRead,BufNewFile bzr_log.*                 set filetype=bzr

" Bzr is STUPID STUPID STUPID finds a lock file created by bzr ci and aborts
" bzr diff
finish

function! Bzr_diff_windows()
    let i = 0
    let add = 0
    let list_of_files = ''
    while i <= line('$')
        let line = getline(i)
        if line =~ '^modified:\|^added:'
            let add = 1
        elseif line =~ '^\S'
            let add = 0
        elseif line =~ '^  ' && add
            let file = substitute(line, "[*]$", "", "")
            let list_of_files = list_of_files . ' ' . file
        endif
        let i = i + 1
    endwhile

    if list_of_files == ""
        return
    endif

    new
    silent! setlocal ft=diff previewwindow bufhidden=delete nobackup noswf nobuflisted nowrap buftype=nofile
    exe 'normal :r!LANG=C cd `bzr root` && bzr diff ' . list_of_files . "\n"
    setlocal nomodifiable
    goto 1
    redraw!
    syn on
endfunction

setlocal nowarn
call Bzr_diff_windows()
setlocal nowb
