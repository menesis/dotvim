if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
" au! BufRead,BufNewFile COMMIT_EDITMSG	setfiletype gitcommit <-- stock vim
" does that now
  au! BufRead,BufNewFile svn-commit.*	setfiletype svn
  au! BufRead,BufNewFile *.cover	setfiletype pycover
  au! BufRead,BufNewFile /var/lib/buildbot/masters/*/*.cfg	setfiletype python
augroup END
