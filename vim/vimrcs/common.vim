" Terminal
" --------

if has('nvim')
    " Creates horizontally split terminal window.
    function! Terminal()
        10 split +terminal
        wincmd J
    endfunction
    nnoremap <Leader>tr :<C-u>call Terminal()<CR>

    " window move
    tnoremap <C-w>h <C-\><C-n><C-w>h
    tnoremap <C-w>j <C-\><C-n><C-w>j
    tnoremap <C-w>k <C-\><C-n><C-w>k
    tnoremap <C-w>l <C-\><C-n><C-w>l
    tnoremap <C-w><C-h> <C-\><C-n><C-w>h
    tnoremap <C-w><C-j> <C-\><C-n><C-w>j
    tnoremap <C-w><C-k> <C-\><C-n><C-w>k
    tnoremap <C-w><C-l> <C-\><C-n><C-w>l
    augroup vimrc_terminal
        au!
        au BufWinEnter,WinEnter term://* startinsert
        au TermOpen term://* setlocal foldcolumn=0 | setlocal winfixheight
    augroup END
endif

" options
" -------

if has('persistent_undo')
    if ! isdirectory($VIMTMP.'/undo')
        call mkdir($VIMTMP.'/undo')
    endif
    set undofile
    set undodir=$VIMTMP/undo
    set undolevels=500  " How many undos
    set undoreload=1000 " number of lines to save for undo
endif

if has('nvim')
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE=2
endif
if !has('nvim') && &term =~ '256color'
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
    set term=xterm-256color
    set t_ut=
endif
if has('termguicolors')
    set termguicolors
endif
set spelllang=en,cjk " use spell check
set showcmd          " Show (partial) command in status line.
set showmatch        " Show matching brackets.
set ignorecase       " Do case insensitive matching
set smartcase        " Do smart case matching
set incsearch        " Incremental search
set hlsearch
set laststatus=2
set autowrite        " Save before commands like :next and :make
set autoread
set hidden           " Hide buffers when they are abandoned
set incsearch
set virtualedit=block " Free move in block selection
set title
set formatoptions+=mM " Multi-byte character format
set list              " Show invisible characters
set listchars=tab:-\ ,trail:-,extends:»,precedes:«,nbsp:+
set scrolloff=3
set clipboard=unnamedplus,unnamed
set mouse=nv
set nonumber
set wildmenu
set wildmode=longest:full
set ambiwidth=double " wide characters
set shiftround
set belloff=all
set viminfo=!,'200,<100,s10,h
if ! isdirectory($VIMTMP.'/swapfiles')
    call mkdir($VIMTMP.'/swapfiles')
endif
set directory=$VIMTMP/swapfiles//
set backupdir=/tmp
set backup
set foldmethod=indent
set foldlevel=100 foldcolumn=0
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp,latin1
set fileformats=unix,dos,mac
set breakindent
set breakindentopt=sbr
set showbreak=>
set emoji
set autoread

" indent
set smartindent
set expandtab
set tabstop=4 shiftwidth=4 softtabstop=4
augroup vimrc_tab_group
    au!
    au FileType html setlocal tabstop=2 shiftwidth=2 softtabstop=2
augroup END

" :Cdc Changes Directory to Current file location
command! Cdc cd %:p:h

" :Vdiff display diff with given args in vertical split window
command! -complete=file -nargs=1 Vdiff vertical diffsplit <args>

" mappings
" --------

noremap Y y$

" not to yank
nnoremap x "_x
vnoremap x "_x
vnoremap p "_dP

" Ctrl-j to Esc
noremap  <C-j> <esc>
inoremap <C-j> <esc>
cnoremap <C-j> <C-c>

" off highlight
nnoremap <esc><esc> :<C-u>nohl<CR>
nnoremap <C-j><C-j> :<C-u>nohl<CR>

nnoremap <Leader>mk :<C-u>make -j2<CR>
nnoremap <Leader>mr :<c-u>make -j2 run<CR>
nnoremap <Leader>mi :<c-u>make -j2 install<CR>
nnoremap <Leader>sp :<c-u>set spell!<CR>

augroup vimrc_cd_to_current_directry
    au!
    au VimEnter * Cdc
augroup END

augroup vimrc_cursorline_only_active_window
    au!
    au VimEnter,BufWinEnter,WinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

filetype plugin indent on

if has("syntax")
    syntax on
endif
