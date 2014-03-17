" ~/.vimrc by Gediminas Paulauskas <menesis@pov.lt>, heavily based on
" ~/.vimrc by Marius Gedminas <marius@gedmin.as>
"

"
" Options                                                       {{{1
"
set nocompatible                " be sane (default if you have a .vimrc)

" Presentation                                                  {{{2
set laststatus=2                " always show a status line
set cmdheight=2                 " avoid 'Press ENTER to continue'
set guioptions-=L               " disable left scrollbar in GUI
set guioptions-=m               " disable GUI menu
set showcmd                     " show partial commands in status line
set ruler                       " show cursor position in status line
set nolist                      " do NOT show tabs and spaces at end of line:
set listchars=tab:>-,trail:.,extends:>
if has("linebreak")
  let &sbr = nr2char(8618).' '  " Show ↪ at the beginning of wrapped lines
endif
if has("extra_search")
  set hlsearch                  " highlight search matches
  nohlsearch                    " but not initially
endif

if v:version >= 600
  set listchars+=precedes:<
endif

if v:version >= 700
  set listchars+=nbsp:_
endif

" Silence                                                       {{{2
set noerrorbells                " don't beep!
set visualbell                  " don't beep!
set t_vb=                       " don't beep! (but also see below)

" Interpreting file contents                                    {{{2
set modelines=5                 " debian disables this by default
set fileencodings=ucs-bom,utf-8,iso-8859-13,latin1 " autodetect
        " Vim cannot distinguish between 8-bit encodings, so the last two
        " won't ever be considered.  I keep them here for convenience:
        " :set fencs=<tab>, then delete the ones you don't want

" Backup files                                                  {{{2
set backup                      " make backups
set backupdir=~/.vim/backup     " but don't clutter $PWD with them
set directory=~/.vim/tmp,/tmp   " list of directories for swap files

if $USER == "root"
  " 'sudo vi' on certain machines cannot write to ~/tmp (NFS root-squash)
  set backupdir=/root/tmp
endif

if !isdirectory(&backupdir)
  " create the backup directory if it doesn't already exist
  exec "silent !mkdir -p " . &backupdir
endif

" Avoiding excessive I/O                                        {{{2
set swapsync=                   " be more friendly to laptop mode (dangerous)
                                " this could result in data loss, so beware!
if v:version >= 700
  set nofsync                   " be more friendly to laptop mode (dangerous)
                                " this could result in data loss, so beware!
endif

" Behaviour                                                     {{{2
set wildmenu                    " nice tab-completion on the command line
set wildmode=longest,full       " nicer tab-completion on the command line
set hidden                      " side effect: undo list is not lost on C-^
set browsedir=buffer            " :browse e starts in %:h, not in $PWD
set autoread                    " automatically reload files changed on disk
set history=1000                " remember more lines of cmdline history
set switchbuf=useopen           " quickfix reuses open windows
set iskeyword-=/                " Ctrl-W in command-line stops at /
set autowrite                   " do not ask to save file
set confirm                     " show a dialog instead of failing

if has('mouse_xterm')
  set mouse=a                   " use mouse in xterms
endif

if v:version >= 600
  set clipboard=unnamed         " interoperate with the X clipboard
  set splitright                " self-explanatory
endif

if v:version >= 700
  set diffopt+=vertical         " split diffs vertically
  set spelllang=en,lt           " spell-check two languages at once
endif

" Input                                                         {{{2

set timeoutlen=1000 ttimeoutlen=20 " timeout keys after 20ms, mappings after 3s
                                " doesn't seem to work for <esc>Ok

" Movement                                                      {{{2
set incsearch                   " incremental searching
set scrolloff=2                 " always keep cursor 2 lines from screen edge
set nostartofline               " don't jump to start of line

" Folding                                                       {{{2
if v:version >= 600
" set foldmethod=marker         " use folding by markers by default
  set foldlevelstart=9999       " initially open all folds
endif

" Editing                                                       {{{2
set backspace=indent,eol,start  " sane backspacing
set nowrap                      " do not wrap long lines
set shiftwidth=4                " more-or-less sane indents
set softtabstop=4               " make the <tab> key more useful
set tabstop=8                   " anything else is heresy
set expandtab                   " sane default
set noshiftround                " do NOT enforce the indent
set autoindent                  " automatic indent
set nosmartindent               " but no smart indent (ain't smart enough)
set isfname-=\=                 " fix filename completion in VAR=/path
if v:version >= 704
  set fo+=j                     " remove comment leader when joining lines
endif

" Other                                                         {{{2
set gdefault
set ignorecase
set nojoinspaces
set matchpairs=(:),{:},[:],<:>
set matchtime=4
set mousehide
set mousemodel=popup_setpos
set report=3
set secure
set showmatch
set noshowmode
set smartcase
set synmaxcol=300
"set notagbsearch
set textwidth=80
set winheight=3
set winwidth=72

" Editing code                                                  {{{2
set path+=**                    " let :find do recursive searches
set tags-=./TAGS                " ignore emacs tags to prevent duplicates
set tags-=TAGS                  " ignore emacs tags to prevent duplicates
set tags-=./tags                " bin/tags is not a tags file;
set tags+=tags;$HOME            " look for tags in parent dirs
set suffixes+=.class            " ignore Java class files
set suffixes+=.pyc,.pyo         " ignore compiled Python files
set suffixes+=.~1~,.~2~         " ignore Bazaar droppings
set wildignore+=*.pyc,*.pyo     " same as 'suffixes', but for tab completion
set wildignore+=*.o,*.d,*.so    " same as 'suffixes', but for tab completion
set wildignore+=*~              " same as 'suffixes', but for tab completion
set wildignore+=local/**        " virtualenv
set wildignore+=build/**        " distutils, I hates them
set wildignore+=htmlcov/**      " coverage.py
set wildignore+=coverage/**     " zope.testrunner --coverage
set wildignore+=parts/omelette/** " collective.recipe.omelette
set wildignore+=parts/**        " all buildout-generated junk even
set wildignore+=lib/**          " virtualenv
set wildignore+=eggs/**         " virtualenv
set wildignore+=.tox/**         " tox
set wildignore+=_build/**       " sphinx
set wildignore+=python/**       " virtualenv called 'python'

if v:version >= 700
  set complete-=i               " don't autocomplete from included files (too slow)
endif

" Python tracebacks (unittest + doctest output)                 {{{2
set errorformat&
set errorformat+=
            \File\ \"%f\"\\,\ line\ %l%.%#,
            \%C\ %.%#,
            \%-A\ \ File\ \"unittest%.py\"\\,\ line\ %.%#,
            \%-A\ \ File\ \"%f\"\\,\ line\ 0%.%#,
            \%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,
            \%Z%[%^\ ]%\\@=%m

" Shell scripts                                                 {{{2
if has("eval")
  let g:is_posix = 1            " /bin/sh is POSIX, not ancient Bourne shell
  let g:sh_fold_enabled = 7     " fold functions, heredocs, ifs/loops
endif
" Persistent undo (vim 7.3+)                                    {{{2
if has("persistent_undo")
  set undofile                  " enable persistent undo
  let &undodir=&backupdir . "/.vimundo" " but don't clutter $PWD
  if !isdirectory(&undodir)
    " create the undo directory if it doesn't already exist
    exec "silent !mkdir -p " . &undodir
  endif
endif

" Netrw explorer                                                {{{2
if has("eval")
  let g:netrw_keepdir = 1                       " does not work!
  let g:netrw_list_hide = '.*\.swp\($\|\t\),.*\.py[co]\($\|\t\)'
  let g:netrw_sort_sequence = '[\/]$,*,\.bak$,\.o$,\.h$,\.info$,\.swp$,\.obj$,\.py[co]$'
  let g:netrw_timefmt = '%Y-%m-%d %H:%M:%S'
  let g:netrw_use_noswf = 1
endif

"
" Plugins                                                       {{{1
"

" Vundle                                                        {{{2
"
" git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
" read documentation at https://github.com/gmarik/vundle#readme
if has("user_commands")
  set rtp+=~/.vim/bundle/vundle/
  set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
  runtime autoload/vundle.vim " apparently without this the exists() check fails
endif
if exists("*vundle#rc")
  " NB:
  "   <graywh> you would want to call vundle#rc() *before* filetype on
  "            so bundles' ftdetect scripts are loaded
  filetype off
  call vundle#rc()

  " install/upgrade vundle itself (there's the obvious chicken and egg problem
  " here); if vundle is missing, bootstrap it with
  "   git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
  Bundle "gmarik/vundle"

  " list all plugins you want to have like this:
  "   Bundle "foo.vim" for vim.org-hosted stuff
  "   Bundle "owner/project" for github-hosted stuff
  "   Bundle "git://git.wincent.com/command-t.git" for arbitrary URLs
  " install ones that are missing with :BundleInstall
  " install/upgrade them all with :BundleInstall!
  " search for new ones with :BundleSearch keyword
  " bundles are kept in ~/.vim/bundle/

  Bundle "mgedmin/python-imports.vim"

  " pure-python alternative to command-t, slightly different UI, seems quite
  " good
  Bundle "ctrlp.vim"

  Bundle "git://git.wincent.com/command-t.git"
  " NB: Bundle doesn't install command-t completely automatically; you have
  " to manually do this:
  "   cd ~/.vim/bundle/command-t/ruby/command-t/ && ruby extconf.rb && make
  " you might also need some packages installed, like build-essential and
  " ruby1.8-dev

  Bundle "scrooloose/syntastic"
  Bundle "Gundo"
  Bundle "Rename"
  Bundle "vcscommand.vim"

  Bundle "davidhalter/jedi-vim"

  " Bundle "fugitive.vim" -- 2-years old version of tpope/vim-fugitive
  Bundle "tpope/vim-fugitive"
  Bundle "tpope/vim-characterize"
  Bundle "tpope/vim-surround"
  Bundle "rhysd/clever-f.vim"

  Bundle "Lokaltog/powerline"

  Bundle "majutsushi/tagbar"
  Bundle "scrooloose/nerdtree"
endif

" Filetype plugins                                              {{{2
if v:version >= 600
  filetype plugin on            " load filetype plugins
  filetype indent on            " load indent plugins
endif

" Syntastic                                                     {{{2

if has("eval")
  let g:syntastic_check_on_open = 1             " default is 0
  let g:syntastic_enable_signs = 1              " default is 1
  let g:syntastic_enable_baloons = 1            " default is 1
  let g:syntastic_enable_highlighting = 1       " default is 1
  let g:syntastic_auto_jump = 0                 " default is 0
  let g:syntastic_auto_loc_list = 2             " default is 2
  let g:syntastic_always_populate_loc_list = 1  " default is 0
" let g:syntastic_quiet_warnings = 1
" let g:syntastic_disabled_filetypes = ['ruby', 'php']

  " statusline format (default: '[Syntax: line:%F (%t)]')
  let g:syntastic_stl_format = '{%t}'

  " fun with unicode
  let g:syntastic_error_symbol = '⚡'
  let g:syntastic_warning_symbol = '⚠'

  " For forcing the use of flake8, pyflakes, or pylint set
" let g:syntastic_python_checker = 'pyflakes' " BBB
  let g:syntastic_python_checkers = ['pyflakes']
" let g:syntastic_python_checkers = ['flake8']
endif

" Command-t                                                     {{{2

if has("eval")
  let g:CommandTCursorEndMap = ['<C-e>', '<End>']
  let g:CommandTCursorStartMap = ['<C-a>', '<Home>']
  let g:CommandTMaxHeight = 20
endif

" Toggle between .c (.cc, .cpp) and .h                          {{{2
" ToggleHeader defined in $HOME/.vim/plugin/cpph.vim

" Maybe these mappings should be moved into FT_C() ?
map             ,h              :call ToggleHeader()<CR>
map             <C-F6>          ,h
imap            <C-F6>          <C-O><C-F6>

" Python syntax highligting                                     {{{2
" from http://hlabs.spb.ru/vim/python.vim
if has("eval")
  let python_highlight_all = 1
  let python_slow_sync = 1
endif

" python_check_syntax.vim                                       {{{2
if has("eval")
  " mnemonic: py[f]lakes (the default \cs is taken by VCSStatus)
  let g:pcs_hotkey = '<LocalLeader>f'
  let g:pcs_check_when_saving = 0  " I use syntastic now

  if has("user_commands")
    command! EnablePyflakesOnSave   let g:pcs_check_when_saving = 1
    command! DisablePyflakesOnSave  exec 'py quickfix.maybeclose()'
                                     \| let g:pcs_check_when_saving = 0
  endif
endif

" py-test-runner.vim                                            {{{2

map             ,t              :CopyTestUnderCursor<cr>

if has("user_commands")
  " :Co now expands to :CommandT, but I'm used to type it as a shortcut for
  " :CopyTestUnderCursor
  command! Co CopyTestUnderCursor
  " :E is now ambiguous, but I'm used to it
  command! E Explore
endif

" XML syntax folding                                            {{{2
if has("eval")
  let xml_syntax_folding = 1
endif

" XML tag complyetion                                           {{{2
if has("eval")
  " because autocompleting when I type > is irritating half of the time
  let xml_tag_completion_map = "<C-l>"
endif

" VCSCommand configuration                                      {{{2
if has("eval")
  " I want 'edit' for VCSAnnotate, but 'split' for all others :(
  let VCSCommandEdit = 'split'
  let VCSCommandDeleteOnHide = 1
  let VCSCommandCommitOnWrite = 0
endif

" git ftplugin                                                  {{{2
if has("eval")
  let git_diff_spawn_mode = 1
endif

" bzr syntax plugin                                             {{{2
if has("eval")
  " NB: it uses an exists() check, so don't set it to 0 if you want it off
  let bzr_highlight_diff = 1
endif

" surround.vim                                                  {{{2
" make it not clobber 's' in visual mode
vmap <Leader>s <Plug>Vsurround
vmap <Leader>S <Plug>VSurround
 
" NERD_tree.vim                                                 {{{2
if v:version >= 700 && has("eval")
  let g:NERDTreeIgnore = ['\.pyc$', '\~$']
  let g:NERDTreeHijackNetrw = 0
endif

" Tagbar                                                        {{{2
"
let g:tagbar_type_rst = {
    \ 'ctagstype': 'rst',
    \ 'ctagsbin' : '~/bin/rst2ctags',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

" jedi.vim                                                      {{{2
if has("eval")
  " show_call_signatures is a hack that modified your source buffer
  " and interacts badly with syntax highlighting
  let g:jedi#show_call_signatures = "0"
  " I type 'import zope.component', I see 'import zope.interfacecomponent'
  " because jedi autocompletes the only zope subpackage it finds in
  " site-packages, unmindful about my virtualenvs/buildouts.
  let g:jedi#popup_select_first = 0
  let g:jedi#popup_on_dot = 0
endif

"
" Status line                                                   {{{1
"

" I need to do this _after_ setting plugin options, since my statusline
" relies on functions defined in some plugins, so I want to try to source
" those plugins early to check if I need to define fallback functions, in
" case those plugins are unavailable.

" To emulate the standard status line with 'ruler' set, use this:
"
"   set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
"
" I've tweaked it a bit to show the buffer number on the left, and the total
" number of lines on the right.  Also, show the current Python function in the
" status line, if the pythonhelper.vim plugin exists and can be loaded.

runtime plugin/syntastic.vim
if !exists("*SyntasticStatuslineFlag")
  function! SyntasticStatuslineFlag()
    return ''
  endfunction
endif

set statusline=                 " my status line contains:
set statusline+=%n:             " - buffer number, followed by a colon
set statusline+=%<%f            " - relative filename, truncated from the left
set statusline+=\               " - a space
set statusline+=%h              " - [Help] if this is a help buffer
set statusline+=%m              " - [+] if modified, [-] if not modifiable
set statusline+=%r              " - [RO] if readonly
set statusline+=%#error#%{SyntasticStatuslineFlag()}%*
set statusline+=\               " - a space
set statusline+=%=              " - right-align the rest
set statusline+=%-10.(%l,%c%V%) " - line,column[-virtual column]
set statusline+=\               " - a space
set statusline+=%4L             " - total number of lines in buffer
set statusline+=\               " - a space
set statusline+=%P              " - position in buffer as percentage

" Other notes:
"   %1*         -- switch to highlight group User1
"   %{}         -- embed the output of a vim function
"   %*          -- switch to the normal highlighting
"   %=          -- right-align the rest
"   %-10.(...%) -- left-align the group inside %(...%)


"
" Commands                                                      {{{1
"

if has("user_commands")

" how many occurrences of the current search pattern?           {{{2
command! CountMatches                   %s///n

" die, trailing whitespace! die!                                {{{2
command! NukeTrailingWhitespace         %s/\s\+$//

" where's that non-ascii character?                             {{{2
command! FindNonAscii                   normal /[^\x00-\x7f]<cr>

" diffoff sets wrap; don't wanna                                {{{2
command! Diffoff                        diffoff | setlocal nowrap

" See :help DiffOrig                                            {{{2
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                  \ | wincmd p | diffthis

" :CW                                                           {{{2
command! CW             botright cw

" :W is something I accidentally type all the time              {{{2
command! W              w

endif " has("user_commands")

"
" Keyboard macros                                               {{{1
"

" Ctrl-L updates diff, recomputes folds                         {{{2

noremap         <C-L>           :diffupdate<CR>zx<C-L>

" Ctrl-_ toggles the presence of _ in 'iskeyword'               {{{2

if has("eval")
  fun! ToggleUnderscoreInKeywords()
    if &isk =~ '_'
       set isk-=_
       echo "_ is not a keyword character"
    else
        set isk+=_
       echo "_ is a keyword character"
    endif
    return ''
  endf
endif

noremap         <C-_>           :call ToggleUnderscoreInKeywords()<CR>
inoremap        <C-_>           <C-R>=ToggleUnderscoreInKeywords()<CR>

" Digraphs                                                      {{{2

if has("digraphs")
  digraph -- 8212               " em dash
  digraph `` 8220               " left double quotation mark
  digraph '' 8221               " right double quotation mark
  digraph ,, 8222               " double low-9 quotation mark
endif

" Remember columns when jumping to marks                        {{{2
map             '               `

" Undo in insert mode                                           {{{2
" make it so that if I accidentally press ^W or ^U in insert mode,
" then <ESC>u will undo just the ^W/^U, and not the whole insert
" This is documented in :help ins-special-special, a few pages down
inoremap <C-W> <C-G>u<C-W>
inoremap <C-U> <C-G>u<C-U>

" The same applies for accidentally pasting the wrong thing while in insert
" mode: you don't want u to undo the text you typed before you mispasted
inoremap <MiddleMouse> <C-G>u<MiddleMouse>

" */# search in visual mode (from www.vim.org)                  {{{2

" Atom \V sets following pattern to "very nomagic", i.e. only the backslash
" has special meaning.
" As a search pattern we insert an expression (= register) that
" calls the 'escape()' function on the unnamed register content '@@',
" and escapes the backslash and the character that still has a special
" meaning in the search command (/|?, respectively).
" This works well even with <Tab> (no need to change ^I into \t),
" but not with a linebreak, which must be changed from ^M to \n.
" This is done with the substitute() function.
" See http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap * y/\V<C-R>=substitute(escape(@@,"/\\"),"\n","\\\\n","ge")<CR><CR>
vnoremap # y?\V<C-R>=substitute(escape(@@,"?\\"),"\n","\\\\n","ge")<CR><CR>

" Diffget/diffput in visual mode                                {{{2

vmap            \do             :diffget<CR>
vmap            \dp             :diffput<CR>

" S-Insert pastes                                               {{{2
map!            <S-Insert>      <MiddleMouse>

" .vimrc editing                                                {{{2
set wildcharm=<C-Z>
map             ,e              :e $HOME/.vim/vimrc<CR>
map             ,s              :source $HOME/.vim/vimrc<CR>

" open a file in the same dir as the current one                {{{2
map <expr>      ,E              ":e ".expand("%:h")."/"
""map <expr>      ,,E             ":e ".expand("%:h:h")."/"
""map <expr>      ,,,E            ":e ".expand("%:h:h:h")."/"
map <expr>      ,R              ":e ".expand("%:r")."."

" close just the deepest level of folds                         {{{2
map             ,zm             zMzRzm

" Scrolling with Ctrl+Up/Down                                   {{{2
map             <C-Up>          1<C-U>
map             <C-Down>        1<C-D>
imap            <C-Up>          <C-O><C-Up>
imap            <C-Down>        <C-O><C-Down>

" Scrolling with Ctrl+Shift+Up/Down                             {{{2
map             <C-S-Up>        1<C-U><Down>
map             <C-S-Down>      1<C-D><Up>
imap            <C-S-Up>        <C-O><C-S-Up>
imap            <C-S-Down>      <C-O><C-S-Down>

" Moving around with Shift+Up/Down                              {{{2
map             <S-Up>          {
map             <S-Down>        }
imap            <S-Up>          <C-O><S-Up>
imap            <S-Down>        <C-O><S-Down>

" Navigating around windows
map             <C-W><C-Up>     <C-W><Up>
map             <C-W><C-Down>   <C-W><Down>
map             <C-W><C-Left>   <C-W><Left>
map             <C-W><C-Right>  <C-W><Right>
map             <C-S-Up>        <C-W><Up>
map             <C-S-Down>      <C-W><Down>
map             <C-S-Left>      <C-W><Left>
map             <C-S-Right>     <C-W><Right>
map!            <C-S-Up>        <C-O><C-W><Up>
map!            <C-S-Down>      <C-O><C-W><Down>
map!            <C-S-Left>      <C-O><C-W><Left>
map!            <C-S-Right>     <C-O><C-W><Right>

" Switching tabs with Alt-1,2,3 in gvim                         {{{2
map             <A-1>           1gt
map             <A-2>           2gt
map             <A-3>           3gt
map             <A-4>           4gt
map             <A-5>           5gt
map             <A-6>           6gt
map             <A-7>           7gt
map             <A-8>           8gt
map             <A-9>           9gt

" Emacs style command line                                      {{{2
cnoremap        <C-G>           <C-C>
cnoremap        <C-A>           <Home>
cnoremap        <Esc>b          <S-Left>
cnoremap        <Esc>f          <S-Right>

" Windows style editing                                         {{{2
imap            <C-Del>         <C-O>dw
imap            <C-Backspace>   <C-O>db

map             <S-Insert>      "+p
imap            <S-Insert>      <C-O><S-Insert>
vmap            <C-Insert>      "+y

" ^Z = undo
imap            <C-Z>           <C-O>u

" Function keys                                                 {{{2

" <F1> = help (default)
"-" Disable F1 -- it gets in the way of F2 on my ThinkPad
""map             <F1>            <Nop>
""imap            <F1>            <Nop>

" <F2> = save
map             <F2>            :update<CR>
imap            <F2>            <C-O><F2>

" <F3> = turn off search highlighting
map             <F3>            :nohlsearch<CR>
imap            <F3>            <C-O><F3>

" <S-F3> = turn off location list
map             <S-F3>            :lclose<CR>
imap            <S-F3>            <C-O><S-F3>

" <C-F3> = turn off quickfix
map             <C-F3>            :cclose<CR>
imap            <C-F3>            <C-O><C-F3>

" <F4> = next error/grep match
"" depends on plugin/quickloclist.vim
map             <F4>            :FirstOrNextInList<CR>
imap            <F4>            <C-O><F4>
" <S-F4> = previous error/grep match
map             <S-F4>          :PrevInList<CR>
imap            <S-F4>          <C-O><S-F4>
" <C-F4> = current error/grep match
map             <C-F4>          :CurInList<CR>
imap            <C-F4>          <C-O><C-F4>

""" <F5> = close location list (overriden by ImportName in .py files)
""map             <F5>            :lclose<CR>
""imap            <F5>            <C-O><F5>

" <F6> = cycle through buffers
map             <F6>            :bn<CR>
imap            <F6>            <C-O><F6>
" <S-F6> = cycle through buffers backwards
map             <S-F6>          :bN<CR>
imap            <S-F6>          <C-O><S-F6>
" <C-F6> = toggle .c/.h (see above) or code/test (see below)

" <F7> = jump to tag/filename+linenumber in the clipboard
map             <F7>            :ClipboardTest<CR>
imap            <F7>            <C-O><F7>

" <F8> = toggle tagbar
" (some file-type dependent autocommands redefine it)
nmap            <F8>            :TagbarToggle<CR>

" <F9> = make
map             <F9>    :make<CR>
imap            <F9>    <C-O><F9>

" <F10> = quit
" (some file-type dependent autocommands redefine it)
""map           <F10>           :q<CR>
""imap          <F10>           <ESC>

" <F11> = toggle 'paste'
set pastetoggle=<F11>


"
" Autocommands                                                  {{{1
"

if has("autocmd")

" Kill visual bell! kill!                                       {{{2

augroup GUI
  au!
  au GUIEnter * set t_vb=
augroup END

" Remember last position in a file                              {{{2
" see :help last-position-jump
augroup LastPositionJump
  au!
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") && &ft != 'gitcommit' | exe "normal g'\"" | endif
augroup END

" Autodetect filetype on first save                             {{{2
augroup FiletypeOnSave
  au!
  au BufWritePost * if &ft == "" | filetype detect | endif
augroup END

" chmod +x on save                                              {{{2
augroup MakeExecutableOnSave
  " http://unix.stackexchange.com/questions/39982/vim-create-file-with-x-bit
  " See also http://vim.wikia.com/wiki/Setting_file_attributes_without_reloading_a_buffer
  au!
  au BufWritePost * if getline(1) =~ "^#!" && expand("%:t") !~ "test.*py" | silent exec '!chmod +x <afile>' | endif
augroup END

" Programming in C/C++                                          {{{2
function! FT_C()
  if v:version >= 600
    setlocal formatoptions=croql
    setlocal cindent
    setlocal comments=sr:/*,mb:*,el:*/,://
    setlocal shiftwidth=4
    if v:version >= 704
      setlocal fo+=j " remove comment leader when joining lines
    endif
  else
    set formatoptions=croql
    set cindent
    set comments=sr:/*,mb:*,el:*/,://
    set shiftwidth=4
  endif
endf

augroup C_prog
  autocmd!
  autocmd FileType c,cpp        call FT_C()
  autocmd BufRead,BufNewFile /home/mg/src/brogue-*/**/*.[ch]  setlocal ts=4
augroup END

" Programming in Java                                           {{{2
function! FT_Java()
  if v:version >= 600
    setlocal formatoptions=croql
    setlocal cindent
    setlocal comments=sr:/*,mb:*,el:*/,://
    setlocal shiftwidth=4
    "setlocal efm=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
    if v:version >= 704
      setlocal fo+=j " remove comment leader when joining lines
    endif
  else
    set formatoptions=croql
    set cindent
    set comments=sr:/*,mb:*,el:*/,://
    set shiftwidth=4
    "set efm=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
  endif
endf

augroup Java_prog
  autocmd!
  autocmd FileType java         call FT_Java()
augroup END

" Programming in Perl                                           {{{2
function! FT_Perl()
  if v:version >= 600
    setlocal formatoptions=croql
""  setlocal smartindent
    setlocal shiftwidth=4
    if v:version >= 704
      setlocal fo+=j " remove comment leader when joining lines
    endif
  else
    set formatoptions=croql
""  set smartindent
    set shiftwidth=4
  endif

  " <S-F9> = check syntax
  map  <buffer> <S-F9>  :!perl -c %<CR>
  imap <buffer> <S-F9>  <C-O><S-F9>
endf

augroup Perl_prog
  autocmd!
  autocmd FileType perl         call FT_Perl()
augroup END

" Programming in Python                                         {{{2

function! PythonFoldLevel(lineno)
  let line = getline(a:lineno)
  " XXX very primitive at the moment
  if line == ''
    let line = getline(a:lineno + 1)
    if line =~ '^\(def\|class\)\>'
      return 0
    elseif line =~ '^    \(def\|class\|#\)\>'
      return 1
    else
      let lvl = foldlevel(a:lineno + 1)
      return lvl >= 0 ? lvl : '-1'
    endif
  elseif line =~ '^\(def\|class\)\>'
    return '>1'
  elseif line =~ '^    \(def\|class\)\>'
    return '>2'
  elseif line =~ '^[^ #]' " # so that comments in the middle of functions don't break folds
    return 0
  elseif line =~ '^    [^ ]' " XXX used to be [^ #], why? what did I break by removing #?
    return 1
  else
    let lvl = foldlevel(a:lineno - 1)
    return lvl >= 0 ? lvl : '='
  endif
endf

function! FT_Python()
  if v:version >= 600
    setlocal formatoptions=croql
    if v:version >= 704
      setlocal fo+=j " remove comment leader when joining lines
    endif
    setlocal shiftwidth=4
    setlocal softtabstop=4 
    setlocal expandtab
    setlocal indentkeys-=<:>
    setlocal indentkeys-=:
    if &foldmethod != 'diff'
      setlocal foldmethod=expr
    endif
    setlocal foldexpr=PythonFoldLevel(v:lnum)
    " I don't want [I to parse import statements and look for modules
    setlocal include=

    syn sync minlines=100

""  match Error /\%>79v.\+/
    map <buffer> <F5>    :ImportName <C-R><C-W><CR>
    map <buffer> <C-F5>  :ImportNameHere <C-R><C-W><CR>
    imap <buffer> <F5>   <C-O><F5>
    imap <buffer> <C-F5> <C-O><C-F5>
    map <buffer> <C-F6>  :SwitchCodeAndTest<CR>
    map <buffer> <F9>    :SyntasticCheck<CR>
    map <buffer> <F10>   :setlocal makeprg=pyflakes\ %\|make<CR>
  else
    set formatoptions=croql
""  set smartindent
    set shiftwidth=4
    set expandtab
  endif

endf

augroup Python_prog
  autocmd!
  autocmd FileType python       call FT_Python()
  autocmd BufRead,BufNewFile *  if expand('%:p') =~ 'schooltool' | let g:pyTestRunnerClipboardExtras='-pvc1' | let g:pyTestRunnerDirectoryFiltering = '' | let g:pyTestRunnerModuleFiltering = '' | endif
  "autocmd FileType python set omnifunc=pythoncomplete#Complete
  "inoremap <C-space> <C-x><C-o>
augroup END


augroup JS_prog
  autocmd!
  autocmd FileType javascript   map <buffer> <C-F6>  :SwitchCodeAndTest<CR>
augroup END


function! FT_Mako()
  setf html
  setlocal includeexpr=substitute(v:fname,'^/','','')
  setlocal indentexpr=
  setlocal indentkeys-={,}
  map <buffer> <C-F6>  :SwitchCodeAndTest<CR>
endf

augroup Mako_templ
  autocmd!
  autocmd BufRead,BufNewFile *.mako     call FT_Mako()
augroup END

" Zope                                                          {{{2

function! FT_XML()
  setf xml
  if v:version >= 700
    setlocal shiftwidth=2 softtabstop=2 expandtab fdm=syntax
  elseif v:version >= 600
    setlocal shiftwidth=2 softtabstop=2 expandtab
    setlocal indentexpr=
  else
    set shiftwidth=2 softtabstop=2 expandtab
  endif
endf

function! FT_Maybe_ReST()
  if glob(expand("%:p:h") . "/*.py") != ""
        \ || glob(expand("%:p:h:h") . "/*.py") != ""
    " Why the FUCK does this FUCKING trigger when I'm editing a Mercurial
    " commit message, after I do :new
    if &ft == "text" || &ft == ""
        setlocal ft=rest
    endif
    setlocal shiftwidth=4 softtabstop=4 expandtab
    map <buffer> <F5>    :ImportName <C-R><C-W><CR>
    map <buffer> <C-F5>  :ImportNameHere <C-R><C-W><CR>
    map <buffer> <C-F6>  :SwitchCodeAndTest<CR>
  endif
endf

augroup Zope
  autocmd!
  autocmd BufRead,BufNewFile *.zcml                     call FT_XML()
  autocmd BufRead,BufNewFile *.pt                       call FT_XML()
  autocmd BufRead,BufNewFile *.tt                       setlocal et tw=44 wiw=44 fo=t
  autocmd BufRead,BufNewFile *.txt                      call FT_Maybe_ReST()
  autocmd BufRead,BufNewFile *.test                     call FT_Maybe_ReST()
augroup END

" Diffs and patches                                             {{{2

function! DiffFoldLevel(lineno)
  let line = getline(a:lineno)
  if line =~ '^Index:'
    return '>1'
  elseif line =~ '^RCS file: ' || line =~ '^retrieving revision '
    let lvl = foldlevel(a:lineno - 1)
    return lvl >= 0 ? lvl : '='
  elseif line =~ '^=== ' && getline(a:lineno - 1) =~ '^$\|^[-+ ]'
    return '>1'
  elseif line =~ '^==='
    let lvl = foldlevel(a:lineno - 1)
    return lvl >= 0 ? lvl : '='
  elseif line =~ '^diff'
    return getline(a:lineno - 1) =~ '^retrieving revision ' ? '=' : '>1'
  elseif line =~ '^--- ' && getline(a:lineno - 1) !~ '^diff\|^==='
    return '>1'
  elseif line =~ '^@'
    return '>2'
  elseif line =~ '^[- +\\]'
    let lvl = foldlevel(a:lineno - 1)
    return lvl >= 0 ? lvl : '='
  else
    return '0'
  endif
endf

function! FT_Diff()
  if v:version >= 600
    setlocal foldmethod=expr
    setlocal foldexpr=DiffFoldLevel(v:lnum)
  else
  endif
endf

augroup Diffs
  autocmd!
  autocmd BufRead,BufNewFile *.patch    setf diff
  autocmd FileType diff                 call FT_Diff()
augroup END

function! FT_PO()
  if !hasmapto('<Plug>DeleteTrans')
    imap <buffer> <S-F4> <Plug>DeleteTrans
  endif
  let g:po_translator='Gediminas Paulauskas <menesis@pov.lt>'
  let g:po_lang_team='Lithuanian <gnome-lt@lists.akl.lt>'
endf

augroup PO
  autocmd!
  autocmd FileType po call FT_PO()
augroup END

" /root/Changelog                                               {{{2

function! FT_RootsChangelog()
  setlocal expandtab
  setlocal formatoptions=crql
  setlocal comments=b:#,fb:-
  if v:version >= 704
    setlocal fo+=j " remove comment leader when joining lines
  endif
endf

augroup RootsChangelog
  autocmd!
  autocmd BufRead,BufNewFile /root/Changelog*   call FT_RootsChangelog()
augroup END


endif " has("autocmd")

"
" Colors                                                        {{{1
"

if $COLORTERM == "gnome-terminal"
  set t_Co=256                  " gnome-terminal supports 256 colors
  " note: doesn't work inside screen, which translates 256 colors into the
  " basic 16.
  " a better fix would be something like http://gist.github.com/636883
  " added to .bashrc
endif

if has("gui_running")
  gui                           " see :help 'background' why I need this before
  set t_vb=                     " this must be set after :gui
endif

set background=dark
let psc_style='warm'
let psc_statement_different_from_type=1
colorscheme ps_color
"colorscheme xoria256

if has("syntax")
  syntax enable
endif

" My colour overrides

highlight NonText               ctermfg=gray guifg=gray term=standout
highlight SpecialKey            ctermfg=gray guifg=gray term=standout
"highlight MatchParen            gui=bold guibg=NONE guifg=lightblue cterm=bold ctermbg=255
highlight SpellBad              cterm=underline ctermfg=red ctermbg=NONE
highlight SpellCap              cterm=underline ctermfg=blue ctermbg=NONE

" Get rid of italics (they look ugly)
highlight htmlItalic            gui=NONE guifg=orange
highlight htmlUnderlineItalic   gui=underline guifg=orange

" Make error messages more readable
highlight ErrorMsg              guifg=red guibg=white

" Python doctests -- I got used to one color, then upgraded the Python
" syntax script and it changed it
highlight link Test Special

" 'statusline' contains %1* and %2*
highlight User1                 gui=NONE guifg=green guibg=black
            \                   cterm=NONE ctermfg=green ctermbg=black
highlight User2                 gui=NONE guifg=magenta guibg=black
            \                   cterm=NONE ctermfg=magenta ctermbg=black

" for custom :match commands
highlight Red                   guibg=red ctermbg=red
highlight Green                 guibg=green ctermbg=green

" for less intrusive signs
highlight SignColumn guibg=NONE ctermbg=NONE
"highlight SignColumn guibg=#fefefe ctermbg=230

" avoid invisible color combination (red on red)
highlight DiffText ctermbg=1

" easier on the eyes
highlight Folded ctermbg=229

