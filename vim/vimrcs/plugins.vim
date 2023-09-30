function! UpdateRemote(arg)
    UpdateRemotePlugins
endfunction
call plug#begin($VIMDIR.'/plugged')
Plug 'psliwka/vim-dirtytalk', { 'do': ':DirtytalkUpdate' } " additional spellcheck dictionary
Plug 'vim-scripts/sudo.vim'
Plug 'thinca/vim-quickrun'
Plug 'scrooloose/nerdcommenter'
Plug 'fuenor/im_control.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-fugitive'
Plug 'kshenoy/vim-signature'
Plug 'airblade/vim-gitgutter'
Plug 'dkarter/bullets.vim'
Plug 'previm/previm'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-obsession'

" Visual
Plug 'lilydjwg/colorizer'
Plug 'itchyny/lightline.vim'
Plug 'EdenEast/nightfox.nvim'

" Language support
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'antoinemadec/coc-fzf', {'branch': 'release'}
Plug 'vim-test/vim-test'
Plug 'fatih/vim-go'
if executable('gotests')
    " Install:
    " go install github.com/cweill/gotests/...@latest
    Plug 'buoto/gotests-vim'
endif
Plug 'pangloss/vim-javascript'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'

call plug#end()

" TreeSitter
" ----------

if index(plugs_order, 'nvim-treesitter') >= 0
    lua <<EOF
    require'nvim-treesitter.configs'.setup {
        ensure_installed = { "cpp", "typescript", "vim", "vimdoc", "go", "gomod", "gowork" },
        sync_install = true,

        auto_install = true,

        highlight = {
            enable = true,
        },
        incremental_selection = {
            enable = true,
        },
        indent = { enable = true },
        textobjects = {
            select = {
                enable = true,
            },
        },
    }
EOF

    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
endif

" Coc
" ---

if index(plugs_order, 'coc.nvim') >= 0
    call coc#add_extension('coc-json', 'coc-snippets')
    " Web
    call coc#add_extension('coc-html', 'coc-css', 'coc-tsserver', 'coc-angular', 'coc-eslint')
    " C
    call coc#add_extension('coc-clangd')
    " Python
    call coc#add_extension('coc-pyright')
    " Go
    call coc#add_extension('coc-go')
    call coc#add_extension('coc-vimlsp')

    nmap <Leader>ac <Plug>(coc-codeaction)
    nmap <Leader>fx <Plug>(coc-fix-current)
    nmap <Leader>if <Plug>(coc-diagnostic-info)
    nmap <Leader>dn :<C-u>CocDiagnostics<CR>
    nmap <Leader>fm <Plug>(coc-format)
    nmap <Leader>nm <Plug>(coc-rename)
    nmap <Leader>us <Plug>(coc-references)
    nmap <Leader>dc <Plug>(coc-declaration)
    nmap <Leader>ip <Plug>(coc-implementation)
    nmap <Leader>rf <Plug>(coc-refactor)
    nmap <Leader>? :call CocActionAsync('doHover')<CR>
    nmap <C-w>u <Plug>(coc-float-jump)
    nmap <Leader>ln <Plug>(coc-codelens-action)
    nmap <Leader>im :<C-u>silent call CocAction('runCommand', 'editor.action.organizeImport')<CR>
    "xmap if <Plug>(coc-funcobj-i)
    "omap if <Plug>(coc-funcobj-i)
    "xmap af <Plug>(coc-funcobj-a)
    "omap af <Plug>(coc-funcobj-a)
    "xmap ic <Plug>(coc-classobj-i)
    "omap ic <Plug>(coc-classobj-i)
    "xmap ac <Plug>(coc-classobj-a)
    "omap ac <Plug>(coc-classobj-a)
    nmap <expr> <C-]> CocHasProvider("definition") ? '<Plug>(coc-definition)' : '<C-]>'
    nmap <expr> <C-w><C-]> CocHasProvider("definition") ? ':call CocAction("jumpDefinition", "vsplit")<CR>' : '<C-w><C-]>'

    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#_select_confirm()
                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    let g:coc_snippet_next = '<C-l>'
    let g:coc_snippet_prev = '<C-k>'

    augroup vimrc_coc_keymap
        au!
        au FileType go nmap <buffer> <Leader>ts :CocCommand go.test.toggle<CR>
    augroup END
endif
if index(plugs_order, 'coc-fzf') >= 0
    nmap <Leader>ou :<C-u>CocFzfList outline<cr>
    nmap <Leader>oc :<C-u>CocFzfList commands<cr>
    nmap <Leader>ol :<C-u>CocFzfList<cr>
endif

" bullets
" -------

if index(plugs_order, 'bullets.vim') >= 0
    if index(plugs_order, 'coc.nvim') >= 0
        " Replace default <CR> mapping so that it also invokes coc expansion
        let g:bullets_set_mappings = 0
        function! ExecuteEnter() abort
            if coc#pum#visible()
                return coc#_select_confirm()
            else
                execute("InsertNewBullet")
            endif
            return coc#on_enter()
        endfunction
        let g:bullets_custom_mappings = [
                    \ ['inoremap', '<CR>',        '<C-r>=ExecuteEnter()<CR>'],
                    \ ['inoremap', '<C-cr>',      '<cr>'],
                    \
                    \ ['nmap',     'o',           '<Plug>(bullets-newline)'],
                    \
                    \ ['vmap',     'gN',          '<Plug>(bullets-renumber)'],
                    \ ['nmap',     'gN',          '<Plug>(bullets-renumber)'],
                    \
                    \ ['nmap',     '<leader>x',   '<Plug>(bullets-toggle-checkbox)'],
                    \
                    \ ['imap',     '<C-t>',       '<Plug>(bullets-demote)'],
                    \ ['nmap',     '>>',          '<Plug>(bullets-demote)'],
                    \ ['vmap',     '>',           '<Plug>(bullets-demote)'],
                    \ ['imap',     '<C-d>',       '<Plug>(bullets-promote)'],
                    \ ['nmap',     '<<',          '<Plug>(bullets-promote)'],
                    \ ['vmap',     '<',           '<Plug>(bullets-promote)'],
                    \ ]
    endif
endif

" vim-test
" --------

if index(plugs_order, 'vim-test') >= 0
    if has('nvim')
        let test#strategy = "neovim"
    else
        let test#strategy = "vimterminal"
    endif
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


" Fzf
" ---

if index(plugs_order, 'fzf.vim') >= 0
    let g:fzf_command_prefix = 'Fzf'
    nnoremap <Leader>ul  :<C-u>FzfLines<CR>
    nnoremap <Leader>ur  :<C-u>FzfFiles<CR>
    nnoremap <Leader>ug  :<C-u>FzfGFiles<CR>
    nnoremap <Leader>us  :<C-u>FzfGFiles?<CR>
    nnoremap <Leader>uh  :<C-u>FzfHistory<CR>
    nnoremap <Leader>b   :<C-u>FzfBuffers<CR>
    nnoremap <Leader>gp  :<C-u>FzfGGrep<Space>

    command! -bang -nargs=? -complete=dir FzfFiles
                \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

    command! -bang -nargs=* FzfGGrep
                \ call fzf#vim#grep(
                \   'git grep --line-number -- '.shellescape(<q-args>), 0,
                \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

    nmap <leader><c-o> <plug>(fzf-maps-n)
    xmap <leader><c-o> <plug>(fzf-maps-x)
    omap <leader><c-o> <plug>(fzf-maps-o)
    imap <c-x><c-f> <plug>(fzf-complete-path)
    imap <c-x><c-l> <plug>(fzf-complete-line)
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

    "let g:go_snippet_engine = "ultisnips"

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

lua << EOF
    require('nightfox').setup({
    palettes = {
        nightfox = {
            bg1 = "#1c222a",
        },
    },
    })

    -- setup must be called before loading
    vim.cmd("colorscheme nightfox")
EOF


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
