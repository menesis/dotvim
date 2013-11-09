" syntax highlight for wdiff output
highlight difPlus ctermfg=lightgreen        guifg=darkgreen	guibg=lightgreen
highlight difMinus ctermfg=lightred         guifg=darkred	guibg=lightred
highlight difDarkPlus ctermfg=darkgreen     guifg=green		guibg=lightgreen
highlight difDarkMinus ctermfg=darkred      guifg=red		guibg=lightred

syntax region difPlus  matchgroup=difDarkPlus  start=/{+/  end=/+}/
syntax region difMinus matchgroup=difDarkMinus start=/\[-/ end=/-\]/
