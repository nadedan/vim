" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible


" ================ General Config ====================

set path+=**
set number                      "Line numbers are good
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim
set cursorline                  "Highlight the row the cursor is on
set cursorcolumn                "Highlight the column that the cursor is on
set virtualedit=all             "Put the cursor anywhere in whitespace
set ls=2                        "status bar at bottom of buffer
set statusline=%<%{&ff}:%{&fenc}:%Y\ \ \|\ \ %f%m\ \ \|\ \ %{strftime('%y/%m/%d\ %H:%M',\ getftime(expand('%')))}\ \ \|\ \ %=\ R:%l\/%L\ C:%c%V\ %P
" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

set complete+=kspell
"set completeopt=menuone,longest,preview
set completeopt=menuone,preview
set shortmess+=c

set guioptions-=m "turn off menu bar
set guioptions-=T "turn off tool bar
set guioptions-=r "turn off scroll bar
set guioptions-=L "turn off scroll bar

"turn on syntax highlighting
syntax on
set ruler
colorscheme evening

highlight highlighter guibg=SlateBlue
" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo') && isdirectory(expand('~').'/.vim/backups')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

" ================ Indentation ======================

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" Auto indent pasted text
"nnoremap p p=`]<C-o>
"nnoremap P P=`]<C-o>

filetype plugin on
filetype indent on


set nowrap       "Don't wrap lines
"set linebreak    "Wrap lines at convenient points

" ================ Folds ============================

"set foldmethod=indent   "fold based on indent
set foldmethod=manual   "fold based on manual
"set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================ Completion =======================

set wildmode=list:full
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.elf,*.lst,*.map
set wildignore+=*.a,*.pub,*.ilk

" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ================ Search ===========================

set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital

" ================ Mappings ===========================

" Save session
map <F11> :mksession! ~\_vim_session<cr>
" Restore session
map <F12> :source ~\_vim_session<cr>

"Set Leader character to space
let mapleader = "\<Space>"

"Faster file write
nnoremap <leader>w :w<cr>

"Use jj to leave insert mode
inoremap jj <esc>

"Search for word under cursor recursively in current dir
noremap <F4> :vimgrep <cword> **/*<cr>

"Show all instances of <cword> in current file
noremap <F5> *N:vimgrep <cword> %<CR>

"Open the list of vimgrep matches
noremap <F6> :copen<cr>

"Move forward through vimgrep matches
noremap <c-n> :cn<cr>

"Move backward through vimgrep matches
noremap <c-m> :cN<cr>

" Window changing
noremap <c-h> <c-w><c-h>
noremap <c-j> <c-w><c-j>
noremap <c-k> <c-w><c-k>
noremap <c-l> <c-w><c-l>

" Window Resizing
nmap <c-left> <c-w><
nmap <c-right> <c-w>>
nmap <c-up> <c-w>+
nmap <c-down> <c-w>-

" Buffer Switching
noremap <c-tab> :bn<cr>
noremap <c-s-tab> :bp<cr>

" Hightlight word under cursor and stay in same place
"nnoremap * /\<<cword>\><cr>N

" Highlight Line under cursor
noremap <leader>hl :call matchadd('highlighter', '\%'.line('.').'l')<CR>

" Highlight Clear
noremap <leader>hc :call clearmatches()<CR>

" Copy selection to System Clipboard
noremap <leader>yt "+y

" Copy full buffer to System Clipboard
noremap <leader>ya ggVG"+y

" Like ya, but also force close the window
noremap <leader>yo ggVG"+y:q!<cr>

" Inner Paste. Replace inner word with clipboard
noremap <leader>ip ciw<c-r>0<esc>

" sql_string add. Wraps the whole buffer to build a sql_string
noremap <leader>ssa :%norm 0isql_str = sql_str & vbLf & "<cr>:%norm A"<cr>

" sql_string delete. Removes the sql_string wrapper
noremap <leader>ssd :%norm df"<cr>:%norm $x<cr>

"Align Block
noremap <leader>ab ms{mb}me`s:'b,'eAlign<cr>

" Close buffer and go to the last buffer
noremap <leader>d :b#<cr>:bdelete #<cr>:bn<cr>:bp<cr>

" Reformat file
noremap <leader>= ggVG=

" ================ Command Mappings ==================
" Edit my vimrc
command! Config execute ":e $MYVIMRC"
" Source my vimrc
command! Reload execute ":source $MYVIMRC"

command! TW execute ":call Trim_whitespace()<cr>

command! -range -nargs=? Align call AlignThis(<line1>, <line2>)
command! -range -nargs=? Ent2Inst call VHDL_ent2inst(<line1>,<line2>)

command! W w

command! -nargs=1 Vgh call Vimgrep_here(<f-args>)
command! -nargs=1 Vgr call Vimgrep_dir(<f-args>)

command! -range -nargs=1 C :<line1>,<line2>s/^/<args>

command! Wcp e clip "+p

" SVN Check Out Here : checks out an SVN directory to the current working directory
command! -nargs=1 -complete=customlist,Complete_SVN_paths SVNcoh :execute "!svn co "<q-args> getcwd()

" SVN Check Out There : checks out an SVN directory to the specified directory
command! -nargs=1 -complete=customlist,Complete_SVN_paths SVNcot :execute "!svn co "<q-args>

" SVN Check In : checks in the current file
"  Takes check in comment as argument
command! -nargs=1 SVNci :execute "!svn ci -m "<q-args> %


inoremap <c-up> <esc>:call GrabNeighbor(-1)<cr>
inoremap <c-down> <esc>:call GrabNeighbor(1)<cr>
inoremap <c-o> <esc>:call PasteAutocomplete()<cr>

com! FormatXML :%!python -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"
nnoremap = :FormatXML<Cr>
" ================ Functions ======================

function! Complete_SVN_paths(ArgLead, CmdLine, CursorPos)

  return [
        \  'svn://training/Business_Reporting/Reports/Project_ETC/'
        \ ,'svn://training/Business_Reporting/Reports/Project_ETC/branches/'
        \]
endfunction

function! Trim_whitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunction

function! Vimgrep_here(search_str)
  exe ':silent vimgrep ' . a:search_str . ' % | copen'
endfunction

function! Vimgrep_dir(search_str)
  exe ':silent vimgrep ' . a:search_str . ' **/* | copen'
endfunction

" Align lines with character under cursor at the cursor column
function! AlignThis(line1, line2)
  let l:cursor_pos = getcurpos()
  let l:column = l:cursor_pos[2]
  let l:character = matchstr(getline('.'), '\%' . col('.') . 'c.')

  exec printf('execute "%i,%i norm f%s40i \<esc>%i|dt%s"', a:line1, a:line2, l:character, l:column, l:character)
endf

function! GrabNeighbor(dir)

  let my_line = line('.')
  let their_line = my_line+a:dir
  let col = col('.')
  call cursor(their_line,col+1)
  normal y$
  call cursor(my_line,col)
  normal p
endf

function! PasteAutocomplete()

  " remember cursor position
  let line = line('.')
  let col = col('.')
  let base = expand("<cword>")
  normal diw
  let hits = []
  let flags = 'w'
  normal G$
  while search('\<'.base, flags) > 0
    let hit = expand("<cword>")
    call add(hits, hit)
    let flags = 'W'
  endwhile
  " restore cursor position
  call cursor(line,col)
  call sort(hits)
  call uniq(hits)
  execute 'let @a = join(uniq(hits), "\n") . "\n"'
  normal "ap

endfunction

function! NMode(id)
  let l:nmode = mode() =~# '[nvViR]'
  if l:nmode
    if !&rnu
      set relativenumber
    endif
  else
    if &rnu
      set norelativenumber
    endif
  endif
endfunction

function! VHDL_ent2inst(line1, line2)
  let my_line = line('.')
  let my_col = col('.')

  exec printf('%i,%is/:/=>  --', a:line1, a:line2)
  exec printf('%i,%is/entity /entity work.', a:line1, a:line2)
  exec printf('%i,%is/ is/', a:line1, a:line2)
  exec printf('%i,%is/generic/generic map', a:line1, a:line2)
  exec printf('%i,%is/port/port map', a:line1, a:line2)
  exec printf('%i,%is/);/)', a:line1, a:line2-1)
  exec printf('%i,%is/;/,', a:line1, a:line2-1)
  call cursor(a:line1,1)
  call search('entity')
  normal wwwywOinst_
  normal pa:
  call cursor(my_line, my_col)
endfunction


"=========================
call timer_start(100, function('NMode'), {'repeat': -1})

" ================ Autocmds ======================

autocmd BufWritePre * :call Trim_whitespace()

