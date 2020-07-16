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

    " set hybrid color
    let g:terminal_color_0 = "#282A2E"
    let g:terminal_color_1 = "#A54242"
    let g:terminal_color_2 = "#8C9440"
    let g:terminal_color_3 = "#DE935F"
    let g:terminal_color_4 = "#5F819D"
    let g:terminal_color_5 = "#85678F"
    let g:terminal_color_6 = "#5E8D87"
    let g:terminal_color_7 = "#707880"
    let g:terminal_color_8 = "#373B41"
    let g:terminal_color_9 = "#CC6666"
    let g:terminal_color_10 = "#B5BD68"
    let g:terminal_color_11 = "#F0C674"
    let g:terminal_color_12 = "#81A2BE"
    let g:terminal_color_13 = "#B294BB"
    let g:terminal_color_14 = "#8ABEB7"
    let g:terminal_color_15 = "#C5C8C6"
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

if !has('nvim') && &term =~ '256color'
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
    set term=xterm-256color
    set t_ut=
endif
if has('termguicolors')
    set termguicolors
    if has('pumblend')
        set pumblend=30
    endif
endif
set spelllang=en,cjk   " use spell check
set showcmd            " Show (partial) command in status line.
set showmatch          " Show matching brackets.
set ignorecase         " Do case insensitive matching
set smartcase          " Do smart case matching
set hlsearch
set laststatus=2
set autowrite          " Save before commands like :next and :make
set autoread
set hidden             " Hide buffers when they are abandoned
set virtualedit=block  " Free move in block selection
set title
set formatoptions+=mM  " Multi-byte character format
set formatoptions-=cro " Disable auto continuation of comments
set list               " Show invisible characters
set listchars=tab:-\ ,trail:-,extends:»,precedes:«,nbsp:+
set scrolloff=3
set clipboard=unnamedplus,unnamed
set mouse=nv
set nonumber
set wildmenu
set wildmode=longest:full
set ambiwidth=double   " wide characters
set shiftround
if exists('+belloff')
    set belloff=all
endif
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
if exists('+breakindent')
    set breakindent
    set breakindentopt=sbr
endif
set showbreak=>
set autoread
set cscopetag " map `C-]` to `g C-]`

" Incremental search
set incsearch
if exists('+inccommand')
    set inccommand=nosplit
endif
if !$HASPLUGIN
    nnoremap / /\v
    nnoremap ? ?\v
    vnoremap / /\v
    vnoremap ? ?\v
endif

" indent
set smartindent
set expandtab
set shiftwidth=0 tabstop=4 softtabstop=4
augroup vimrc_tab_group
    au!
    au FileType html,yaml,json,javascript,typescript,typescript.tsx,typescriptreact setlocal tabstop=2 softtabstop=2
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

" Ctrl-j to Esc
noremap  <C-j> <ESC>
inoremap <C-j> <ESC>
cnoremap <C-j> <C-c>
snoremap <C-j> <C-c>

" off highlight
nnoremap <esc><esc> :<C-u>nohl<CR>
nnoremap <C-j><C-j> :<C-u>nohl<CR>

nnoremap <Leader>mk :<C-u>make -j2<CR>
nnoremap <Leader>mr :<C-u>make -j2 run<CR>
nnoremap <Leader>mi :<C-u>make -j2 install<CR>
nnoremap <Leader>sp :<C-u>setlocal spell!<CR>

" Yank file path
nnoremap <Leader>pf :<C-u>let @+=expand("%")<CR>
nnoremap <Leader>pl :<C-u>let @+=printf("%s:%d", expand("%"), line('.'))<CR>
vnoremap <Leader>pl :<C-u>let @+=printf("%s:%d-%d", expand("%"), line("'<"), line("'>"))<CR>
nnoremap <Leader>pc :<C-u>let @+=printf("%s:%d:%d", expand("%"), line('.'), col('.'))<CR>

nnoremap <Leader>e :<C-u>Explore<CR>
nnoremap <Leader>nl :<C-u>Lexplore<CR>
nnoremap <Leader>nt :<C-u>Texplore<CR>
nnoremap <Leader>ns :<C-u>Hexplore<CR>
nnoremap <Leader>nv :<C-u>Vexplore<CR>
nnoremap <Leader>nr :<C-u>Rexplore<CR>

" Auto indent paste
function! s:map_auto_indent_paste()
    nnoremap <buffer> p p=\`]
    nnoremap <buffer> _p p
endfunction
augroup vimrc_auto_indent_paste
    au!
    au FileType javascript,javascript.jsx,json,typescript,vim,java,ruby,c,cpp,go,bash,sh,zsh
                \ call s:map_auto_indent_paste()
augroup END

" prevent to make a file named ]
cnoreabbrev w] w

augroup vimrc_cursorline_only_active_window
    au!
    au VimEnter,BufWinEnter,WinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

" Git
function! s:get_giturl(first, last)
    let l:lines = ""
    if a:first == a:last
        let l:lines = "\#L" . a:first
    else
        let l:lines = "\#L" . a:first . "-L" . a:last
    endif
    return Chomp(system("git ls-remote --get-url origin | sed -Ee 's@:@/@' -e 's\#(git@|git://)\#https://\#' -e 's/.git$//'")) . '/blob/' . Chomp(system('git rev-parse --abbrev-ref HEAD')) . '/' . @% . l:lines
endfunction
command! -range Gurl echo s:get_giturl(<line1>, <line2>)
command! -range Gurlyank let @+ = s:get_giturl(<line1>, <line2>)

augroup vimrc_spell_on_in_git_commit_message
    au!
    au BufNewFile,BufRead COMMIT_EDITMSG setlocal spell | setlocal spellcapcheck=
    au FileType gitcommit setlocal spell | setlocal spellcapcheck=
augroup END

filetype plugin indent on

if has("syntax")
    syntax enable
endif
