function! UpdateRemote(arg)
    UpdateRemotePlugins
endfunction
call plug#begin($VIMDIR.'/plugged')
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': function('UpdateRemote') }
    Plug 'zchee/deoplete-go'
    Plug 'carlitux/deoplete-ternjs'
    Plug 'Shougo/denite.nvim', { 'do': function('UpdateRemote') }
else
    Plug 'Shougo/neocomplete.vim'
    Plug 'Shougo/unite.vim'
    Plug 'Shougo/unite-outline'
    Plug 'Shougo/neomru.vim'
endif
Plug 'vim-scripts/sudo.vim'
Plug 'thinca/vim-quickrun'
Plug 'lilydjwg/colorizer'
Plug 'scrooloose/nerdcommenter'
Plug 'benekastah/neomake'
Plug 'fatih/vim-go'
Plug 'majutsushi/tagbar'
Plug 'fuenor/im_control.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'itchyny/lightline.vim'
Plug 'w0ng/vim-hybrid'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'ternjs/tern_for_vim'
Plug 'kshenoy/vim-signature'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
"Plug 'othree/yajs.vim'
Plug 'airblade/vim-gitgutter'
"Plug 'cohama/lexima.vim'
call plug#end()


" Tern
" ----

if has('nvim')
    " Use deoplete.
    let g:tern_request_timeout = 1
    let g:tern_show_signature_in_pum = 0  " This do disable full signature type on autocomplete
endif

" Use tern_for_vim.
let g:tern#command = ["tern"]
let g:tern#arguments = ["--persistent"]

augroup vimrc_turn_keymap
    au!
    au filetype javascript nnoremap <buffer> <leader>if :<c-u>TernType<cr>
    au filetype javascript nnoremap <buffer> <leader>nm :<c-u>TernRename<cr>
    au filetype javascript nnoremap <buffer> <leader>us :<c-u>TernRefs<cr>

    au filetype javascript nnoremap <buffer> <C-]>      :<c-u>TernDef<cr>
    au filetype javascript nnoremap <buffer> <C-w><C-]> :<c-u>TernDefsplit<cr>
augroup end


" Unite
" -----

if index(plugs_order, 'unite.vim') >= 0
    call unite#custom#profile('default', 'context', {
                \   'start_insert': 1,
                \   'winheight': 10,
                \   'direction': 'botright',
                \ })

    nnoremap <Leader>un  :<C-u>Unite<Space>
    nnoremap <Leader>uo  :<C-u>Unite outline<CR>
    nnoremap <Leader>uf  :<C-u>Unite file<CR>
    nnoremap <Leader>ur  :<C-u>Unite file_rec<CR>
    nnoremap <Leader>ua  :<C-u>Unite file_mru buffer file<CR>
    nnoremap <Leader>b   :<C-u>Unite buffer<CR>
    nnoremap <Leader>ubm :<C-u>Unite bookmark<CR>

    let g:unite_source_menu_menus = {}

    augroup vimrc_unite_map
        au!
        autocmd FileType unite imap <buffer> <ESC> <Plug>(unite_exit)
        autocmd FileType unite imap <buffer> <C-[> <Plug>(unite_exit)
        autocmd FileType unite imap <buffer> <C-j> <Plug>(unite_exit)
    augroup end
endif


" Denite
" ------

if index(plugs_order, 'denite.nvim') >= 0
    nnoremap <Leader>un  :<C-u>Denite<Space>
    nnoremap <Leader>uo  :<C-u>Denite outline<CR>
    nnoremap <Leader>ur  :<C-u>Denite file_rec<CR>
    nnoremap <Leader>ua  :<C-u>Denite file_old buffer file<CR>
    nnoremap <Leader>b   :<C-u>Denite buffer<CR>

    call denite#custom#map('insert', '<C-j>', '<denite:leave_mode>', 'noremap')
    call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
    call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')
endif

" Deoplete
" --------

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#sources#go = 'vim-go'


" Neocomplete
" -----------

let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#auto_completion_start_length = 3


" Neosnippet
" ----------

if index(plugs_order, 'neosnippet.vim') >= 0
    imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
                \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
    smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
                \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
endif


" Lexima
" ------

if index(plugs_order, 'lexima.vim') >= 0
    imap <C-h> <BS>
    cmap <C-h> <BS>
    let g:lexima_map_escape = '<C-j>'
    let g:lexima_enable_space_rules = 0
    " braces only in basic rules
    let g:lexima_enable_basic_rules = 0
    call lexima#add_rule({'char': '(', 'input_after': ')'})
    call lexima#add_rule({'char': '(', 'at': '\\\%#'})
    call lexima#add_rule({'char': ')', 'at': '\%#)', 'leave': 1})
    call lexima#add_rule({'char': '<BS>', 'at': '(\%#)', 'delete': 1})
    call lexima#add_rule({'char': '{', 'input_after': '}'})
    call lexima#add_rule({'char': '}', 'at': '\%#}', 'leave': 1})
    call lexima#add_rule({'char': '<BS>', 'at': '{\%#}', 'delete': 1})
    call lexima#add_rule({'char': '[', 'input_after': ']'})
    call lexima#add_rule({'char': '[', 'at': '\\\%#'})
    call lexima#add_rule({'char': ']', 'at': '\%#]', 'leave': 1})
endif


" Tagber
" ------

nnoremap <Leader>tg :TagbarToggle<CR>


" Vim-go
" ------

if index(plugs_order, 'vim-go') >= 0
    augroup vimrc_vim_go_keymap
        au!
        au FileType go nmap <buffer> <Leader>im <Plug>(go-imports)
        au FileType go nmap <buffer> <Leader>if <Plug>(go-info)
        au FileType go nmap <buffer> <Leader>nm <Plug>(go-rename)
        au FileType go nmap <buffer> <Leader>us <Plug>(go-referrers)
        au FileType go nmap <buffer> <Leader>lt <Plug>(go-metalinter)

        au FileType go nmap <buffer> <leader>r  <Plug>(go-run-split)
        au FileType go nmap <buffer> <C-]>      <Plug>(go-def)
        au FileType go nmap <buffer> <C-w><C-]> <Plug>(go-def-split)
    augroup END

    let g:go_snippet_engine = "ultisnips"
    "let g:go_auto_sameids = 1
    let g:go_auto_type_info = 1

    let g:go_highlight_functions = 1
    "let g:go_highlight_methods = 1
    "let g:go_highlight_fields = 1
    let g:go_highlight_types = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_build_constraints = 1
    let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck', 'gosimple', 'staticcheck', 'unused']
endif


" lightline
" ---------

set noshowmode

let g:lightline = {
            \ 'colorscheme': 'wombat',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
            \ },
            \ 'component': {
            \   'readonly': '%{&filetype=="help"?"":&readonly?"✖":""}',
            \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
            \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
            \ },
            \ 'component_visible_condition': {
            \   'readonly': '(&filetype!="help"&& &readonly)',
            \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
            \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
            \ }
            \ }


" quick run
" ---------

let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config._ = {
            \ 'outputter' : 'error',
            \ 'outputter/error/success' : 'buffer',
            \ 'outputter/error/error'   : 'quickfix',
            \ 'outputter/buffer/split' : ':botright 8sp',
            \ 'outputter/buffer/close_on_empty' : 1,
            \ }
let g:quickrun_config.cpp = {
            \   'command': 'g++',
            \   'cmdopt': '-std=c++11'
            \ }

" press q to close quickfix
augroup vimrc_quickfix_q
    au!
    au FileType qf nnoremap <silent><buffer>q :quit<CR>
augroup END

" C-c to stop quickrun
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"


" ultisnipets
" -----------

if index(plugs_order, 'ultisnips') >= 0
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<c-l>"
    let g:UltiSnipsJumpBackwardTrigger="<c-k>"

    let g:UltiSnipsEditSplit="vertical"
    let g:UltiSnipsSnippetsDir=$VIMDIR
endif

" incsearch
" ---------

if index(plugs_order, 'incsearch.vim') >= 0
    map /  <Plug>(incsearch-forward)
    map ?  <Plug>(incsearch-backward)
    map g/ <Plug>(incsearch-stay)
    map n  <Plug>(incsearch-nohl-n)
    map N  <Plug>(incsearch-nohl-N)
    map *  <Plug>(incsearch-nohl-*)
    map #  <Plug>(incsearch-nohl-#)
    map g* <Plug>(incsearch-nohl-g*)
    map g# <Plug>(incsearch-nohl-g#)

    let g:incsearch#auto_nohlsearch = 1
    let g:incsearch#magic = '\v' " very magic

    function! s:incsearch_keymap()
        IncSearchNoreMap <C-f> <Over>(incsearch-scroll-f)
        IncSearchNoreMap <C-b> <Over>(incsearch-scroll-b)
    endfunction
    augroup vimrc_incsearch_keymap
        au!
        au VimEnter * call s:incsearch_keymap()
    augroup END
endif


" im_control
" ----------

" fcitx
let g:IM_CtrlMode = 6
inoremap <silent> <C-j> <C-r>=IMState('FixMode')<CR>
set timeout timeoutlen=3000 ttimeoutlen=100


" Colorscheme
" -----------

if index(plugs_order, 'colorizer') >= 0
    set background=dark
    colorscheme hybrid
endif


" Neomake
" -------

if index(plugs_order, 'neomake') >= 0
    " Callback for reloading file in buffer when eslint has finished and maybe has
    " autofixed some stuff
    "function! s:Neomake_callback()
        "if (&filetype ==? 'javascript')
            "edit
        "endif
    "endfunction

    augroup vimrc_neomake_aug
        au!
        " Call neomake#Make directly instead of the Neomake provided command so we can
        " inject the callback
        "au BufWritePost * call neomake#Make(1, [], function('g:Neomake_callback'))
        au BufWritePost * Neomake
        "au User NeomakeFinished call s:Neomake_callback()
    augroup END

    let g:neomake_open_list = 2
    "let g:neomake_javascript_eslint_args = ['-f', 'compact', '--fix']
    "let g:neomake_javascript_enabled_makers = ['eslint']
    "let g:neomake_hook_context = { 'file_mode': 1, 'make_id': 1 }

    "let g:neomake_go_errcheck_maker = {
                "\ 'append_file': 0,
                "\ 'errorformat': '%f:%l:%c:\ %m, %f:%l:%c\ %#%m',
                "\ }
endif

