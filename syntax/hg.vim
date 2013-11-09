" Vim syntax file
" Language:	hg commit file
" Maintainer:	Marius Gedminas <marius@gedmin.as>
" Filenames:	/tmp/hg-editor-*.txt
" Last Change:	2012 July 8

" Based on gitcommit.vim by Tim Pope

if exists("b:current_syntax")
  finish
endif

syn case match
syn sync minlines=50

if has("spell")
  syn spell toplevel
endif

syn include @hgDiff syntax/diff.vim
syn region hgDiff start=/^\%(diff -r\)\@=/ end=/^\%(diff -r\)\@=/ fold contains=@hgDiff

syn match   hgComment	"^HG: .*"

hi def link hgComment		Comment

let b:current_syntax = "hg"

