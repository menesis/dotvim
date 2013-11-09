" Vim syntax file
" Language:     Python code coverage reports
" Maintainer:   Marius Gedminas <mgedmin@delfi.lt>
" Last Change:  2003 Oct 1

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
    syn clear
elseif exists("b:current_syntax")
    finish
endif

syn match  pycoverCount		"^[ 0-9]\{5}: " display
syn region pycoverMissing	matchgroup=pycoverCount start="^>>>>>> " end="$" display
syn region pycoverNotCode	matchgroup=pycoverCount start="^ \{7}" end="$" display

setlocal nolist

if version >= 508 || !exists("did_pycover_syntax_inits")
    if version < 508
        let did_pycover_syntax_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif

    HiLink pycoverMissing	WarningMsg
    HiLink pycoverCount		FoldColumn
    HiLink pycoverNotCode	Comment

    delcommand HiLink
endif

let b:current_syntax = "pycover"

