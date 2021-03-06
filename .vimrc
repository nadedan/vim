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
"set virtualedit=all             "Put the cursor anywhere in whitespace
set ls=2                        "status bar at bottom of buffer
" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden
set virtualedit=block

"turn on syntax highlighting
syntax on
set ruler
colorscheme torte
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

" Display tabs and trailing spaces visually
"set list listchars=tab:\ \ ,trail:·

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" ================ Folds ============================

set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================ Completion =======================

set wildmode=list:full
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

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
"Search for word under cursor recursively in current dir
noremap <F4> :vimgrep <cword> **/*<cr>

"Show all instances of <cword> in current file
noremap <F5> *N:vimgrep <cword> %<CR>

noremap <F6> :copen<cr>

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
"nnoremap * *N

" Copy full buffer to System Clipboard
noremap <leader>ya ggVG"+y

" Inner Paste. Replace inner word with clipboard
noremap <leader>ip ciw<c-r>0<esc>

" ================ Command Mappings ==================
command! -range -nargs=? Align call AlignThis(<line1>, <line2>)
command! -range -nargs=? Ent2Inst call VHDL_ent2inst(<line1>,<line2>)

command! W w

command! -nargs=1 Vgh call Vimgrep_here(<f-args>)
command! -nargs=1 Vgr call Vimgrep_dir(<f-args>)

command! Wcp e clip "+p

inoremap <c-up> <esc>:call GrabNeighbor(-1)<cr>
inoremap <c-down> <esc>:call GrabNeighbor(1)<cr>
inoremap <c-o> <esc>:call PasteAutocomplete()<cr>
" ================ Functions ======================
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

function! NMode_RNU(id)
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
call timer_start(100, function('NMode_RNU'), {'repeat': -1})

