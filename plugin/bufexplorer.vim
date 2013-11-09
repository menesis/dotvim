"=============================================================================
"    Copyright: Copyright (C) 2001 Jeff Lanzarotta
"               Permission is hereby granted to use and distribute this code,
"               with or without modifications, provided that this copyright
"               notice is copied with it. Like anything else that's free,
"               bufexplorer.vim is provided *as is* and comes with no
"               warranty of any kind, either expressed or implied. In no
"               event will the copyright holder be liable for any damamges
"               resulting from the use of this software.
" Name Of File: bufexplorer.vim
"  Description: Buffer Explorer Vim Plugin
"   Maintainer: Jeff Lanzarotta (jefflanzarotta@yahoo.com)
"          URL: http://lanzarotta.tripod.com/vim/plugin/6/bufexplorer.vim.zip
"  Last Change: Monday, December 17, 2001
"      Version: 6.0.9
"        Usage: Normally, this file should reside in the plugins
"               directory and be automatically sourced. If not, you must
"               manually source this file using ':source bufexplorer.vim'.
"
"               You may use the default keymappings of
"
"                 <Leader>be  - Opens BufExplorer
"                 <Leader>bs  - Opens split windows BufExplorer
"
"               For more help see supplied documentation.
"
"      History: See supplied documentation.
"=============================================================================

" Has this already been loaded?
if exists("loaded_bufexplorer")
  finish
endif

let loaded_bufexplorer = 1

" Setup the global MRUList and the autocommand that modify it.
let g:MRUList = ','
au BufEnter * silent call <SID>MRUPush()
au BufDelete * silent call <SID>MRUPop()

if !hasmapto('<Plug>StartBufExplorer')
  map <unique> <Leader>be <Plug>StartBufExplorer
endif

if !hasmapto('<Plug>SplitBufExplorer')
  map <unique> <Leader>bs <Plug>SplitBufExplorer
endif

map <unique> <script> <Plug>StartBufExplorer :call <SID>StartBufExplorer(0)<CR>
map <unique> <script> <Plug>SplitBufExplorer :call <SID>StartBufExplorer(1)<CR>

" Create commands.
if !exists(':BufExplorer')
  command BufExplorer :call <SID>StartBufExplorer(0)
endif

if !exists(':SBufExplorer')
  command SBufExplorer :call <SID>StartBufExplorer(1)
endif

" Show detailed help by default?
" 0 = Don't show, 1 = Do show.
if !exists("g:bufExplorerDetailedHelp")
  let g:bufExplorerDetailedHelp = 0
endif

" Field to sort by
" Can by either 'number', 'name' or 'mru'.
if !exists("g:bufExplorerSortBy")
  let g:bufExplorerSortBy = 'number'
endif

" When opening a new windows, split the new windows below or above the
" current window?  1 = below, 0 = above.
if !exists("g:bufExplorerSplitBelow")
  let g:bufExplorerSplitBelow = &splitbelow
endif

" Whether to sort in forward or reverse order.
if !exists("g:bufExplorerSortDirection")
  let g:bufExplorerSortDirection = 1
  let s:sortDirLabel = ""
else
  let s:sortDirLabel = "reverse"
endif

" Whether to split out the path and file name or not.
" 0 = Don't split, 1 = Do split.
if !exists("g:bufExplorerSplitOutPathName")
  let s:splitOutPathName = 1
endif

" Characters that must be escaped for a regular expression.
let s:escregexp = "/*^$.~\[]"
let s:hideNames = "\\[[^\\]]*\\]"

" StartBufExplorer
function! <SID>StartBufExplorer(split)
  let _splitbelow = &splitbelow

  " Save current and alternate buffer numbers for later.
  let s:curBufNbr = bufnr("%")
  let s:altBufNbr = bufnr("#")

  " Set to our new values.
  let &splitbelow = g:bufExplorerSplitBelow

  if a:split || (&modified && &hidden == 0)
    if has("win32")
      sp [BufExplorer]
    else
      sp \[BufExplorer\]
    endif

    let s:bufExplorerSplitWindow = 1
  else
    if has("win32")
      e [BufExplorer]
    else
      e \[BufExplorer\]
    endif

    let s:bufExplorerSplitWindow = 0
  endif

  call <SID>DisplayBuffers()

  let &splitbelow = _splitbelow

  unlet _splitbelow
endfunction

" DisplayBuffers.
function! <SID>DisplayBuffers()
  let _showcmd = &showcmd

  setlocal bufhidden=delete
  setlocal buftype=nofile
  setlocal modifiable
  setlocal noswapfile
  setlocal nowrap

  set noshowcmd

  if has("syntax")
    call <SID>SetupSyntax()
  endif

  if exists("s:longHelp")
    let w:longHelp = s:longHelp
  else
    let w:longHelp = g:bufExplorerDetailedHelp
  endif

  nnoremap <buffer> <silent> <cr> :call <SID>SelectBuffer()<cr>
  nnoremap <buffer> <silent> d :call <SID>DeleteBuffer()<cr>
  nnoremap <buffer> <silent> p :call <SID>ToggleSplitOutPathName()<cr>
  nnoremap <buffer> <silent> q :call <SID>BackToPreviousBuffer()<cr>
  nnoremap <buffer> <silent> s :call <SID>SortSelect()<cr>
  nnoremap <buffer> <silent> r :call <SID>SortReverse()<cr>
  nnoremap <buffer> <silent> ? :call <SID>ToggleHelp()<cr>
  nnoremap <buffer> <silent> <2-leftmouse> :call <SID>DoubleClick()<cr>

  nnoremap <buffer> <silent> m :call <SID>MRUListShow()<cr>

  " mg: surround.vim maps dd, which causes vim to wait for timeoutlen
  " after I press d, which causes me to think the actual command for
  " deleting a buffer is dd, so I then press d again and delete *two* buffers
  nnoremap <buffer> <silent> dd :call <SID>DeleteBuffer()<cr>

  call <SID>ShowBuffers()

  normal! zz

  setlocal nomodifiable

  let &showcmd = _showcmd

  unlet! _showcmd
endfunction

" SetupSyntax.
if has("syntax")
  function! <SID>SetupSyntax()
    syn match bufExplorerHelp     "^\"[ -].*"
    syn match bufExplorerHelpEnd  "^\"=.*$"
    syn match bufExplorerSortBy   "^\" Sorted by .*$"
    syn match bufExplorerBufNbr   /^\s*\d\+/

    syn match bufExplorerBufFlg transparent contains=@bufExpFlags /^\s*\d\+.\{6}/
    syn cluster bufExpFlags contains=bufExplorerBufNbr,bufExpFlagUnlisted,bufExpFlagCurBuf,bufExpFlagAltBuf,bufExpFlagHidBuf,bufExpFlagActBuf,bufExpFlagModBuf,bufExpFlagLockedBuf,bufExpFlagTagged
    syn match bufExpFlagUnlisted contained /u/
    syn match bufExpFlagCurBuf contained /%/
    syn match bufExpFlagAltBuf contained /#/
    syn match bufExpFlagHidBuf contained /h/
    syn match bufExpFlagActBuf contained /a/
    syn match bufExpFlagModBuf contained /+/
    syn match bufExpFlagLockedBuf contained /[\-=]/
    syn match bufExpFlagTagged contained /\*/
    syn match bufExplorerUnlisted contains=bufExplorerBufFlg /^\s*\d\+u.*$/
    syn match bufExplorerHidBuf contains=bufExplorerBufFlg /^\s*\d\+[u ][%# ]h.*$/
    syn match bufExplorerActBuf contains=bufExplorerBufFlg /^\s*\d\+[u ][%# ]a.*$/
    syn match bufExplorerCurBuf contains=bufExplorerBufFlg /^\s*\d\+[u ]%.*$/
    syn match bufExplorerAltBuf contains=bufExplorerBufFlg /^\s*\d\+[u ]#.*$/
    syn match bufExplorerModBuf contains=bufExplorerBufFlg /^\s*\d\+[u ][%# ][ha ][\-= ]+.*$/
    syn match bufExplorerLockedBuf contains=bufExplorerBufFlg /^\s*\d\+[u ][%# ][ha ][\-=].*$/

    if !exists("g:did_bufexplorer_syntax_inits")
      let g:did_bufexplorer_syntax_inits = 1
      hi def link bufExplorerHelp Special
      hi def link bufExplorerHelpEnd Special
      hi def link bufExplorerSortBy String
      hi def link bufExplorerBufNbr Number

      hi def link bufExpFlagUnlisted Comment
      hi def link bufExpFlagHidBuf Constant
      hi def link bufExpFlagActBuf Identifier
      hi def link bufExpFlagCurBuf Type
      hi def link bufExpFlagAltBuf String
      hi def link bufExpFlagModBuf PreProc
      hi def link bufExpFlagLockedBuf Special
      hi def link bufExpFlagTagged Statement
      hi def link bufExplorerUnlisted bufExpFlagUnlisted
      hi def link bufExplorerHidBuf bufExpFlagHidBuf
      hi def link bufExplorerActBuf bufExpFlagActBuf
      hi def link bufExplorerCurBuf bufExpFlagCurBuf
      hi def link bufExplorerAltBuf bufExpFlagAltBuf
      hi def link bufExplorerModBuf bufExpFlagModBuf
      hi def link bufExplorerLockedBuf bufExpFlagLockedBuf
    endif
  endfunction
endif

" AddHeader.
function! <SID>AddHeader()
  1
  if w:longHelp == 1
    let header = "\" Buffer Explorer\n"
    let header = header."\" ----------------\n"
    let header = header."\" <enter> or Mouse-Double-Click : open buffer under cursor\n"
    let header = header."\" d : delete buffer\n"
    let header = header."\" p : toggle spliting of file and path name\n"
    let header = header."\" q : quit the Buffer Explorer\n"
    let header = header."\" s : select sort field    r : reverse sort\n"
    let header = header."\" ? : toggle this help\n"
  else
    let header = "\" Press ? for Help\n"
  endif

  let header = header."\" Sorted by ".s:sortDirLabel.g:bufExplorerSortBy."\n"
  let header = header."\"=\n"

  put! =header

  unlet header
endfunction

" ShowBuffers.
function! <SID>ShowBuffers()
  let _report = &report
  let &report = 10000

  " Delete all lines in buffer.
  silent 1,$d _

  call <SID>AddHeader()

  $ d _
  " Prevent odd huge indent when first invoked.
  normal 0

  let a_save = @a

  redir @a
    silent ls
  redir END

  let filenames = @a
  let @a = a_save
  unlet a_save

  " Remove the *line* and double quotes from the lines.
  let filenames = substitute(filenames, "\\(\\s*\\d\\+[^\"]\\{-}\\)\\%(\"\\)\\([^\"]\\+\\)\\%(\"[^\n]*\\)\\(\n\\|$\\)", "\\1\\2\\3", "g")

  " Hide [.*] Buffer names ([No File], [BufExplorer],...)
  let redone = 0
  while match(filenames, "\\%(^\\|\n\\)\\%(\\s*\\d\\+.\\{6}" . s:hideNames . "\\%(\n\\|$\\)\\|\n\n\\|\n$\\|^\n\\)") != -1 && redone < 100
    let filenames = substitute(filenames, "\\%(\\%(\n\\|^\\)[^\n]*" . s:hideNames . "\\)\\(\n\\|$\\)", "\n", "g")
    let filenames = substitute(filenames, "\\%(\n\n\\+\\|^\n\\+\\|\n\\+$\\)", "", "g")
    let redone = redone + 1
  endwhile

  if filenames != ""
    " Mark the current and alternate buffers.
    if match(filenames, "\\%(^\\|\n\\)\\s*" . s:curBufNbr . "[u ]") != -1
      let filenames = substitute(filenames, "\\(\\%(^\\|\n\\)\\s*\\d\\+\\%( \\|u\\)\\)%", "\\1 ", "")
      let filenames = substitute(filenames, "\\(\\%(^\\|\n\\)\\s*" . s:curBufNbr . "\\%( \\|u\\)\\).", "\\1%", "")
    endif

    if match(filenames, "\\%(^\\|\n\\)\\s*" . s:altBufNbr . "[u ]") != -1
      let filenames = substitute(filenames, "\\(\\%(^\\|\n\\)\\s*\\d\\+\\%( \\|u\\)\\)#", "\\1 ", "")
      let filenames = substitute(filenames, "\\(\\%(^\\|\n\\)\\s*" . s:altBufNbr . "\\%( \\|u\\)\\).", "\\1#", "")
    endif
  else
    let filenames = "\" No buffers to display!"
  endif

  " Get the line number of the last line of the header + 1.
  let firstLine = line(".") + 1

  put = filenames

  if s:splitOutPathName
    execute firstLine . ",$call <SID>SplitOutPathName()"
  endif

  call <SID>SortListing()

  let &report = _report

  unlet! filenames _report firstLine
endfunction

" SplitOutPathName.
function! <SID>SplitOutPathName() range
  if a:firstline != a:lastline
    let maxlen = 0
    let scanline = a:firstline
    let leaderlen = strlen(matchstr(getline("."), "^\\s*\\d\\+.\\{6}"))

    while scanline <= a:lastline
      let _cnr = <SID>ExtractBufferNbr(getline(scanline))
      let linelen = strlen(expand("#" . _cnr . ":p:t"))

      if linelen + leaderlen > maxlen
        let maxlen = linelen + leaderlen
      endif

      let scanline = scanline + 1
    endwhile

    let scanline = a:firstline

    while scanline <= a:lastline
      let _cfile = getline(scanline)
      let _cnr = <SID>ExtractBufferNbr(_cfile)
      let _cfile = matchstr(_cfile, "^\\s*\\d\\+.\\{6}") . expand("#" . _cnr . ":p:t")
      let pad = maxlen - strlen(_cfile)
      let padloop = 0

      while padloop < pad
        let _cfile = _cfile . " "
        let padloop = padloop + 1
      endwhile

      let _cfile = _cfile . " " . expand("#" . _cnr . ":p:h")
      call setline(scanline, _cfile)
      let scanline = scanline + 1
    endwhile
  endif
endfunction

" SelectBuffer.
function! <SID>SelectBuffer()
  let _showcmd = &showcmd
  set noshowcmd

  let _line = getline('.')

  " Are we on a line with a file name?
  if _line =~'^"'
    unlet _line
    return
  endif

  " let _cfile = <SID>ExtractFileName(_cfile)
  let _bufNbr = <SID>ExtractBufferNbr(_line)
  if bufexists(_bufNbr) != 0
    " Switch to the previously open buffer. This sets the alternate file
    " to the correct one, so that when we switch to the new buffer, the
    " alternate buffer is correct.
    exec("b! ".s:curBufNbr)
    " Open the new buffer.
    exec("b! "._bufNbr)

		call <SID>MRUPush()
  else
    setlocal modifiable
    d _
    setlocal nomodifiable
    echoerr "That buffer no longer exists, please select another"
  endif

  let &showcmd = _showcmd

  unlet! _line _bufNbr _showcmd
endfunction

" Delete selected buffer from list.
function! <SID>DeleteBuffer()
  let _report = &report
  let _showcmd = &showcmd
  let &report = 10000
  set noshowcmd

  setlocal modifiable

  let _bufNbr = <SID>ExtractBufferNbr(getline('.'))

  exec("bd "._bufNbr)
  d _

  setlocal nomodifiable

  let &report = _report
  let &showcmd = _showcmd

  unlet _bufNbr _report _showcmd
endfunction

" Back To Previous Buffer.
function! <SID>BackToPreviousBuffer()
  let _showcmd = &showcmd
  set noshowcmd

  if(s:bufExplorerSplitWindow == 1)
    exec("silent! close!")
  endif

  let switched = 0

  if(s:altBufNbr != -1)
    if filereadable(bufname(s:altBufNbr))
      exec("b! ".s:altBufNbr)
      let switched = 1
    endif
  endif

  if(s:curBufNbr != -1)
    if filereadable(bufname(s:curBufNbr))
      exec("b! ".s:curBufNbr)
      let switched = 1
    endif
  endif

  if switched == 0
    if s:bufExplorerSplitWindow == 1 && bufwinnr("$") > 1
      new
    else
      enew
    endif
  endif

  let &showcmd = _showcmd

  unlet _showcmd
endfunction

" Toggle between short and long help
function! <SID>ToggleHelp()
  if exists("w:longHelp") && w:longHelp==0
    let w:longHelp=1
    let s:longHelp=1
  else
    let w:longHelp=0
    let s:longHelp=0
  endif

  call <SID>UpdateHeader()
endfunction

" ToggleSplitOutPathName
function! <SID>ToggleSplitOutPathName()
  let _showcmd = &showcmd
  set noshowcmd
  let s:splitOutPathName = !s:splitOutPathName
  setlocal modifiable

  call <SID>SaveCursorPosition()
  call <SID>ShowBuffers()
  call <SID>RestoreCursorPosition()

  setlocal nomodifiable
  let &showcmd = _showcmd
  unlet! _showcmd
endfunction

" Update the header
function! <SID>UpdateHeader()
  let _report = &report
  let _showcmd = &showcmd
  let &report = 10000
  set noshowcmd
  setlocal modifiable

  " Save position
  normal! mZ

  " Remove old header
  0
  1,/^"=/ d _

  " Add new header
  call <SID>AddHeader()

  " Go back where we came from if possible.
  0
  if line("'Z") != 0
    normal! `Z
  endif

  let &report = _report
  let &showcmd = _showcmd

  setlocal nomodifiable

  unlet _report _showcmd
endfunction

" ExtractFileName
function! <SID>ExtractFileName(line)
  return strpart(a:line, strlen(matchstr(a:line, "^\\s*\\d\\+")) + 6)
endfunction

" ExtractBufferNbr
function! <SID>ExtractBufferNbr(line)
  return matchstr(a:line, "\\d\\+") + 0
endfunction

" FileNameCmp
function! <SID>FileNameCmp(line1, line2, direction)
  let f1 = <SID>ExtractFileName(a:line1)
  let f2 = <SID>ExtractFileName(a:line2)
  return <SID>StrCmp(f1, f2, a:direction)
endfunction

" BufferNumberCmp
function! <SID>BufferNumberCmp(line1, line2, direction)
  let f1 = <SID>ExtractBufferNbr(a:line1)
  let f2 = <SID>ExtractBufferNbr(a:line2)
  return <SID>StrCmp(f1, f2, a:direction)
endfunction

" StrCmp
function! <SID>StrCmp(line1, line2, direction)
  if a:line1 < a:line2
    return -a:direction
  elseif a:line1 > a:line2
    return a:direction
  else
    return 0
  endif
endfunction

" MRUCmp
function! <SID>MRUCmp(line1, line2, direction)
	let n1 = <SID>ExtractBufferNbr(a:line1)
	let n2 = <SID>ExtractBufferNbr(a:line2)

	let i1 = stridx(g:MRUList, ','.n1.',')
	let i2 = stridx(g:MRUList, ','.n2.',')

	return a:direction*(i1 - i2)
endfunction

" SortR() is called recursively.
function! <SID>SortR(start, end, cmp, direction)
  " Bottom of the recursion if start reaches end
  if a:start >= a:end
    return
  endif

  let partition = a:start - 1
  let middle = partition
  let partStr = getline((a:start + a:end) / 2)

  let i = a:start

  while (i <= a:end)
    let str = getline(i)

    exec "let result = " . a:cmp . "(str, partStr, " . a:direction . ")"

    if result <= 0
      " Need to put it before the partition.  Swap lines i and partition.
      let partition = partition + 1

      if result == 0
        let middle = partition
      endif

      if i != partition
        let str2 = getline(partition)
        call setline(i, str2)
        call setline(partition, str)
      endif
    endif

    let i = i + 1
  endwhile

  " Now we have a pointer to the "middle" element, as far as partitioning
  " goes, which could be anywhere before the partition.  Make sure it is at
  " the end of the partition.
  if middle != partition
    let str = getline(middle)
    let str2 = getline(partition)
    call setline(middle, str2)
    call setline(partition, str)
  endif

  call <SID>SortR(a:start, partition - 1, a:cmp, a:direction)
  call <SID>SortR(partition + 1, a:end, a:cmp, a:direction)
endfunction

" Sort
function! <SID>Sort(cmp, direction) range
  call <SID>SortR(a:firstline, a:lastline, a:cmp, a:direction)
endfunction

" SortReverse
function! <SID>SortReverse()
  if g:bufExplorerSortDirection == -1
    let g:bufExplorerSortDirection = 1
    let s:sortDirLabel = ""
  else
    let g:bufExplorerSortDirection = -1
    let s:sortDirLabel = "reverse "
  endif

  call <SID>SaveCursorPosition()
  call <SID>SortListing()
  call <SID>RestoreCursorPosition()
endfunction

" SortSelect
function! <SID>SortSelect()
  " Select the next sort option
  if !exists("g:bufExplorerSortBy")
    let g:bufExplorerSortBy = "number"
  elseif g:bufExplorerSortBy == "number"
    let g:bufExplorerSortBy = "name"
  elseif g:bufExplorerSortBy == "name"
    let g:bufExplorerSortBy = "mru"
	elseif g:bufExplorerSortBy == "mru"
		let g:bufExplorerSortBy = "number"
	endif

  call <SID>SaveCursorPosition()
  call <SID>SortListing()
  call <SID>RestoreCursorPosition()
endfunction

" SortListing
function! <SID>SortListing()
  let startline = getline(".")

  setlocal modifiable

  " Do the sort.
  0
  if g:bufExplorerSortBy == "number"
    let cmpFunction = "<SID>BufferNumberCmp"
  elseif g:bufExplorerSortBy == "name"
    let cmpFunction = "<SID>FileNameCmp"
  else
    let cmpFunction = "<SID>MRUCmp"
  endif

  /^"=/+1,$call <SID>Sort(cmpFunction, g:bufExplorerSortDirection)

  " Replace the header with updated information.
  call <SID>UpdateHeader()

  setlocal nomodified
  setlocal nomodifiable

  unlet startline cmpFunction
endfunction

" SaveCursorPosition
function! <SID>SaveCursorPosition()
  let s:curLine = winline()
  let s:curColumn = wincol()
endfunction

" RestoreCursorPosition
function! <SID>RestoreCursorPosition()
  execute s:curLine
  execute "normal! " . s:curColumn . "|"
endfunction

" DoubleClick - Double click with the mouse.
function! <SID>DoubleClick()
  call <SID>SelectBuffer()
endfunction

" MRUPush
function! <SID>MRUPush()
  if !buflisted(bufnr('%'))
    return
  end

  let _bufNbr = bufnr('%')
  "echomsg "Pushing ["._bufNbr."]"
  let _list = substitute(g:MRUList, ','._bufNbr.',', ',', '')
  let g:MRUList = ','._bufNbr._list
  "echomsg "After Push, MRUList=[".g:MRUList."]"
  unlet _bufNbr _list
endfunction

" MRUPop
function! <SID>MRUPop()
  let _bufNbr = expand('<abuf>')
  "echomsg "Popping ["._bufNbr."]"
  let g:MRUList = substitute(g:MRUList, ''._bufNbr.',', '', '')
  "echomsg "After Pop, MRUList=[".g:MRUList."]"
  unlet _bufNbr
endfunction

" MRUListShow
function! <SID>MRUListShow()
  echomsg "MRUList=[".g:MRUList."]"
endfunction
