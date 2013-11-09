" made by Michael Scherer ( misc@mandrake.org )
" $Id: svn.vim 282 2005-01-31 21:24:55Z misc $
"
" 2004-09-13 : Lukas Ruf ( lukas.ruf@lpr.ch )
"   - re-ordered windows
"   - set focus on svn-commit.tmp (that's where one has to write)
"   - set buffer type of new window to 'nofile' to fix 'TODO'
"
" 2005-01-31 : 
"   - autoclose on exit, thanks to Gintautas Miliauskas ( gintas@akl.lt )
"     and tips from Marius Gedminas ( mgedmin@b4net.lt )
"     
" 2005-02-08 :
"   - rewrite in pure vim function, from Kyosuke Takayama ( support@mc.neweb.ne.jp )
"   - simplified installation instruction, from Marius Gedminas ( mgedmin@b4net.lt )   
"   
" to use it, place it in ~/.vim/plugins ( create the directory if it doesn't exist ) 

function! Svn_diff_windows()
    let i = 0
    let list_of_files = ''

    while i <= line('$') && getline(i) != '--This line, and those below, will be ignored--'
        let i = i + 1
    endwhile
    while i <= line('$')
        let line = getline(i)
        if line =~ '^[AM]'
            let file = substitute(line, '\v^[AM]M?\s*[+]?\s*(.*)\s*$', '\1', '')
            let file = "'".substitute(file, "'", "'\''", '')."'"
            let list_of_files = list_of_files . ' '.file
        endif

        let i = i + 1
    endwhile

    if list_of_files == ""
        return
    endif

    pclose
    new
    setlocal bufhidden=delete nobackup noswf nobuflisted nowrap buftype=nofile
    if v:version < 704 || v:version > 704 || has("patch007")
        " setlocal previewwindow is broken on 7.4 before 7.4.007
        " -- the window is empty and nonfocusable
        setlocal previewwindow
    endif
    setlocal ft=diff
    exe ':r!LANG=C svn diff --diff-cmd diff -x -up ' . list_of_files
    setlocal nomodifiable
    goto 1
    redraw!
"    wincmd R
"    wincmd p
"    goto 1
"   redraw!
    syn on
endfunction

function! s:empty_commit_message()
  return getline(1) == '' && getline(2) =~ '^--This line.*ignored--'
endfunction

set nowarn

if v:version >= 700
  let filename = findfile('.svnheader', '.;')
  if filereadable(filename) && s:empty_commit_message()
    mark '
    :exec "0read " . filename
    ''
  endif
endif

call Svn_diff_windows()
set nowb
