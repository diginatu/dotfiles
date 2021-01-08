function! UpdateRemote(arg)
    UpdateRemotePlugins
endfunction
call plug#begin($VIMDIR.'/plugged')
"if has('python3')
    "Plug 'Shougo/denite.nvim', { 'do': function('UpdateRemote') }
"endif
Plug 'vim-scripts/sudo.vim'
Plug 'thinca/vim-quickrun'
Plug 'lilydjwg/colorizer'
Plug 'scrooloose/nerdcommenter'
Plug 'fuenor/im_control.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'itchyny/lightline.vim'
Plug 'w0ng/vim-hybrid'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'kshenoy/vim-signature'
Plug 'airblade/vim-gitgutter'
Plug 'cohama/lexima.vim'
Plug 'dkarter/bullets.vim'
Plug 'previm/previm'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Language support
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'antoinemadec/coc-fzf', {'branch': 'release'}
"Plug 'prabirshrestha/async.vim'
"Plug 'prabirshrestha/vim-lsp'

Plug 'fatih/vim-go'
if executable('gotests')
    " Install:
    " go get -u github.com/cweill/gotests/...
    Plug 'buoto/gotests-vim'
endif
Plug 'pangloss/vim-javascript'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'aklt/plantuml-syntax'

call plug#end()

" Coc
" ---

if index(plugs_order, 'coc.nvim') >= 0
    call coc#add_extension('coc-json', 'coc-ultisnips')
    " Web
    "call coc#add_extension('coc-html', 'coc-css', 'coc-tsserver', 'coc-angular', 'coc-eslint')
    call coc#add_extension('coc-vimlsp')

    nmap <Leader>ac <Plug>(coc-codeaction)
    nmap <Leader>fx <Plug>(coc-fix-current)
    nmap <Leader>if <Plug>(coc-diagnostic-info)
    nmap <Leader>fm <Plug>(coc-format)
    nmap <Leader>nm <Plug>(coc-rename)
    nmap <Leader>us <Plug>(coc-references)
    nmap <Leader>dc <Plug>(coc-declaration)
    nmap <Leader>rf <Plug>(coc-refactor)
    nmap <C-w>u <Plug>(coc-float-jump)
    nmap <Leader>ln <Plug>(coc-codelens-action)
    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap ic <Plug>(coc-classobj-i)
    omap ic <Plug>(coc-classobj-i)
    xmap ac <Plug>(coc-classobj-a)
    omap ac <Plug>(coc-classobj-a)
    nmap <expr> <C-]> CocHasProvider("definition") ? '<Plug>(coc-definition)' : '<C-]>'
    inoremap <silent><expr> <C-n> coc#refresh()
    "inoremap <silent><expr> <Tab>
                "\ pumvisible() ? coc#_select_confirm() :
                "\ coc#expandableOrJumpable() ?
                "\ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" : "\<Tab>"

    let g:coc_snippet_next = '<Tab>'
endif
if index(plugs_order, 'coc-fzf') >= 0
    nmap <Leader>uo :<C-u>CocFzfList outline<cr>
endif

" vim-lsp
" -------

if index(plugs_order, 'vim-lsp') >= 0
    let g:lsp_signs_enabled = 1           " enable signs
    let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode

    function! s:map_lsp_funcs() abort
        nmap <buffer> <Leader>ac <Plug>(lsp-code-action)
        nmap <buffer> <Leader>ft <Plug>(lsp-document-format)
        nmap <buffer> <Leader>if <Plug>(lsp-hover)
        nmap <buffer> <Leader>ua <Plug>(lsp-workspace-symbol)
        nmap <buffer> <Leader>nm <Plug>(lsp-rename)
        nmap <buffer> <Leader>us <Plug>(lsp-references)
        nmap <buffer> <C-]>      <Plug>(lsp-definition)
        nmap <buffer> <C-w><C-]> <Plug>(lsp-peek-definition)
    endfunction

    if executable('typescript-language-server')
        augroup vimrc_lsp_typescript
            au!
            au User lsp_setup call lsp#register_server({
                        \ 'name': 'javascript support using typescript-language-server',
                        \ 'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
                        \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
                        \ 'whitelist': ['javascript', 'javascript.jsx']
                        \ })
            au FileType javascript,javascript.jsx call s:map_lsp_funcs()
        augroup end
    endif
endif



" Denite
" ------

if index(plugs_order, 'denite.nvim') >= 0
    nnoremap <Leader>un  :<C-u>Denite<Space>
    nnoremap <Leader>uo  :<C-u>Denite outline<CR>
    nnoremap <Leader>ur  :<C-u>Denite file/rec<CR>
    nnoremap <Leader>ug  :<C-u>Denite file/rec/git<CR>
    nnoremap <Leader>uh  :<C-u>Denite file/old buffer file<CR>
    nnoremap <Leader>up  :<C-u>Denite register<CR>
    nnoremap <Leader>b   :<C-u>Denite buffer<CR>

    augroup vimrc_denite_map
        au!
        autocmd FileType denite call s:denite_my_settings()
        function! s:denite_my_settings() abort
            nnoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
            nnoremap <silent><buffer><expr> d denite#do_map('do_action', 'delete')
            nnoremap <silent><buffer><expr> p denite#do_map('do_action', 'preview')
            nnoremap <silent><buffer><expr><nowait> <C-j> denite#do_map('quit')
            nnoremap <silent><buffer><expr> q denite#do_map('quit')
            nnoremap <silent><buffer><expr> i denite#do_map('open_filter_buffer')
            nnoremap <silent><buffer><expr> <Space> denite#do_map('toggle_select').'j'
            nnoremap <silent><buffer><expr> <Tab> denite#do_map('choose_action')
        endfunction
        autocmd FileType denite-filter call s:denite_filter_my_settings()
        function! s:denite_filter_my_settings() abort
            imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
        endfunction
    augroup end

	call denite#custom#alias('source', 'file/rec/git', 'file/rec')
	call denite#custom#var('file/rec/git', 'command',
	      \ ['git', 'ls-files', '-co', '--exclude-standard'])
endif


" Fzf
" ---

if index(plugs_order, 'fzf.vim') >= 0
    let g:fzf_command_prefix = 'Fzf'
    nnoremap <Leader>ul  :<C-u>FzfLines<CR>
    nnoremap <Leader>ur  :<C-u>FzfFiles<CR>
    nnoremap <Leader>ug  :<C-u>FzfGFiles<CR>
    nnoremap <Leader>uh  :<C-u>FzfHistory<CR>
    nnoremap <Leader>up  :<C-u>Denite register<CR>
    nnoremap <Leader>b   :<C-u>FzfBuffers<CR>
    nnoremap <Leader>gp   :<C-u>FzfGGrep<Space>

    command! -bang -nargs=? -complete=dir FzfFiles
                \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', 'cat {}']}, <bang>0)

    command! -bang -nargs=* FzfGGrep
                \ call fzf#vim#grep(
                \   'git grep --line-number -- '.shellescape(<q-args>), 0,
                \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

    imap <c-x><c-f> <plug>(fzf-complete-path)
    imap <c-x><c-l> <plug>(fzf-complete-line)
endif



" Deoplete
" --------

if index(plugs_order, 'deoplete.nvim') >= 0
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#enable_smart_case = 1

    call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })
endif


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
    call lexima#add_rule({'char': '(', 'input_after': ')', 'at': '\%#[)}\]]*$'})
    call lexima#add_rule({'char': '(', 'at': '\\\%#'})
    call lexima#add_rule({'char': ')', 'at': '\%#)', 'leave': 1})
    call lexima#add_rule({'char': '<BS>', 'at': '(\%#)', 'delete': 1})
    call lexima#add_rule({'char': '{', 'input_after': '}', 'at': '\%#[)}\]]*$'})
    call lexima#add_rule({'char': '}', 'at': '\%#}', 'leave': 1})
    call lexima#add_rule({'char': '<BS>', 'at': '{\%#}', 'delete': 1})
    call lexima#add_rule({'char': '[', 'input_after': ']', 'at': '\%#[)}\]]*$'})
    call lexima#add_rule({'char': '[', 'at': '\\\%#'})
    call lexima#add_rule({'char': ']', 'at': '\%#]', 'leave': 1})
endif


" Tagber
" ------

if index(plugs_order, 'tagbar') >= 0
    nnoremap <Leader>tg :TagbarToggle<CR>
endif


" Vim-go
" ------

if index(plugs_order, 'vim-go') >= 0
    augroup vimrc_vim_go_keymap
        au!
        au FileType go nmap <buffer> <Leader>im <Plug>(go-imports)
        au FileType go nmap <buffer> <Leader>if <Plug>(go-info)
        au FileType go nmap <buffer> <Leader>us <Plug>(go-referrers)
        au FileType go nmap <buffer> <Leader>lt <Plug>(go-metalinter)

        au FileType go nmap <buffer> <leader>r  <Plug>(go-run-split)
        au FileType go nmap <buffer> <C-]>      <Plug>(go-def)
        au FileType go nmap <buffer> <C-w><C-]> <Plug>(go-def-split)
    augroup END

    let g:go_snippet_engine = "ultisnips"

    let g:go_highlight_functions = 1
    "let g:go_highlight_methods = 1
    "let g:go_highlight_fields = 1
    let g:go_highlight_types = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_build_constraints = 1
endif


" lightline
" ---------

if index(plugs_order, 'lightline.vim') >= 0
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
endif


" quick run
" ---------

if index(plugs_order, 'vim-quickrun') >= 0
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
endif


" ultisnipets
" -----------

if index(plugs_order, 'ultisnips') >= 0
    let g:UltiSnipsExpandTrigger = "<tab>"
    let g:UltiSnipsJumpForwardTrigger = "<c-l>"
    let g:UltiSnipsJumpBackwardTrigger = "<c-k>"

    let g:UltiSnipsEditSplit = "vertical"
    let g:UltiSnipsRemoveSelectModeMappings = 0
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

" Firenvim
" --------

if index(plugs_order, 'firenvim') >= 0
    let g:firenvim_config = {
        \ 'localSettings': {
            \ '.*': {
                \ 'takeover': 'never',
                \ 'priority': 0,
            \ }
        \ }
    \ }
endif




" im_control
" ----------

if index(plugs_order, 'im_control.vim') >= 0
    let g:IM_CtrlEnable = 1

    if has("mac")
        let g:IM_CtrlOnKey = 'osascript -e "tell application \"System Events\" to key code 104"'
        let g:IM_CtrlOffKey = 'osascript -e "tell application \"System Events\" to key code 102"'
        let g:IM_CtrlEnable = 0

        augroup vimrc_im_control
            au!
            au FileType markdown,text let g:IM_CtrlEnable = 1
        augroup END
    else
        let g:IM_CtrlOnKey = 'fcitx-remote -o'
        let g:IM_CtrlOffKey = 'fcitx-remote -c'
    endif

    function! IMCtrl(cmd)
        if g:IM_CtrlEnable
            let cmd = a:cmd
            if cmd == 'On'
                let res = system(g:IM_CtrlOnKey)
            elseif cmd == 'Off'
                let res = system(g:IM_CtrlOffKey)
            elseif cmd == 'Toggle'
            endif
        endif
        return ''
    endfunction

    let g:IM_CtrlMode = 1

    nnoremap <Leader>jp :<C-u>let g:IM_CtrlEnable = !g:IM_CtrlEnable<CR>:echo 'IM Ctrl : ' . (g:IM_CtrlEnable?'On':'Off')<CR>
    inoremap <silent> <C-w> <C-r>=IMState('FixMode')<CR>
endif


" Colorscheme
" -----------

if index(plugs_order, 'vim-hybrid') >= 0
    set background=dark
    colorscheme hybrid
endif


" Neomake
" -------

if index(plugs_order, 'neomake') >= 0
    " Callback for reloading file in buffer when eslint has finished and maybe has
    " autofixed some stuff
    function! s:Neomake_callback()
        if (g:neomake_hook_context.jobinfo.ft ==? 'javascript')
            edit
        endif
    endfunction

    augroup vimrc_neomake_aug
        au!
        au BufWritePost * Neomake
        au User NeomakeJobFinished call s:Neomake_callback()
    augroup END

    let g:neomake_open_list = 2
    let g:neomake_javascript_eslint_args = ['-f', 'compact', '--fix']
    let g:neomake_go_gometalinter_args = ['--disable-all', '--enable=errcheck', '--enable=megacheck', '--enable=golint', '--enable=vet']
endif


" GitGutter
" ---------

if index(plugs_order, 'vim-gitgutter') >= 0
    set updatetime=1000
    let g:gitgutter_map_keys = 0
    nmap <Leader>hN <Plug>(GitGutterPrevHunk)
    nmap <Leader>hn <Plug>(GitGutterNextHunk)
    nmap <Leader>hs <Plug>(GitGutterStageHunk)
    nmap <Leader>hu <Plug>(GitGutterUndoHunk)
    nmap <Leader>hp <Plug>(GitGutterPreviewHunk)
endif

if index(plugs_order, 'plantuml-syntax') >= 0
    let g:plantuml_set_makeprg=0
endif


" Previm
" ------

if index(plugs_order, 'previm') >= 0
    let g:previm_open_cmd=g:system_open
endif
