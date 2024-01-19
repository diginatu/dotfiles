-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Visual
    {
        'sainnhe/edge',
        lazy = false,
        priority = 1000,
        config = function ()
            vim.g.edge_better_performance = 1
            vim.g.edge_transparent_background = 1
            vim.cmd.colorscheme("edge")
            if vim.env.THEME_MODE == 'light' then
                vim.opt.background = 'light'
            else
                vim.opt.background = 'dark'
            end
        end
    },
    'lilydjwg/colorizer',
    {
        'itchyny/lightline.vim',
        dependencies = { 'sainnhe/edge' },
        config = function ()
            vim.o.showmode = false
            vim.g.lightline = {
                colorscheme = 'edge',
                active = {
                    left = {
                        { 'mode', 'paste' },
                        { 'fugitive', 'readonly', 'filename', 'modified' },
                    },
                },
                component = {
                    readonly = '%{&filetype=="help"?"":&readonly?"✖":""}',
                    modified = '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
                    fugitive = '%{exists("*fugitive#head")?fugitive#head():""}',
                },
                component_visible_condition = {
                    readonly = '(&filetype!="help"&& &readonly)',
                    modified = '(&filetype!="help"&&(&modified||!&modifiable))',
                    fugitive = '(exists("*fugitive#head") && ""!=fugitive#head())',
                },
            }
        end,
    },
    {
        -- Additional spellcheck dictionary
        'psliwka/vim-dirtytalk',
        build = ':DirtytalkUpdate',
    },
    'vim-scripts/sudo.vim',
    'scrooloose/nerdcommenter',
    {
        'fuenor/im_control.vim',
        config = function ()
            vim.g.IM_CtrlEnable = 1

            vim.cmd([[
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
            ]])
        end,
    },
    {
        'SirVer/ultisnips',
        config = function ()
            vim.g.UltiSnipsExpandTrigger = '<tab>'
            vim.g.UltiSnipsJumpForwardTrigger = '<C-l>'
            vim.g.UltiSnipsJumpBackwardTrigger = '<C-k>'
            vim.g.UltiSnipsEditSplit = 'vertical'
            vim.g.UltiSnipsRemoveSelectModeMappings = 0
        end,
    },
    'honza/vim-snippets',
    'tpope/vim-repeat',
    'tpope/vim-surround',
    'tpope/vim-speeddating',
    'tpope/vim-fugitive',
    'kshenoy/vim-signature',
    {
        'airblade/vim-gitgutter',
        config = function ()
            vim.g.gitgutter_map_keys = 0
            vim.o.updatetime = 1000
            vim.keymap.set('n', '<leader>hN', '<Plug>(GitGutterPrevHunk)')
            vim.keymap.set('n', '<leader>hn', '<Plug>(GitGutterNextHunk)')
            vim.keymap.set('n', '<leader>hs', '<Plug>(GitGutterStageHunk)')
            vim.keymap.set('n', '<leader>hu', '<Plug>(GitGutterUndoHunk)')
            vim.keymap.set('n', '<leader>hp', '<Plug>(GitGutterPreviewHunk)')
        end,
    },
    {
        'dkarter/bullets.vim',
        config = function ()
            vim.g.bullets_custom_mappings = 0
            vim.cmd([[
            " Replace default <CR> mapping so that it also invokes coc expansion
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
                ]])
            end,
        },
        {
            'previm/previm',
            config = function ()
                vim.g.previm_open_cmd = vim.g.system_open
            end,
        },
        'junegunn/vim-easy-align',
        {
            'junegunn/fzf',
            build = ':call fzf#install()',
        },
        {
            'junegunn/fzf.vim',
            lazy = false,
            dependencies = { 'junegunn/fzf' },
            init = function ()
                vim.g.fzf_command_prefix = 'Fzf'
            end,
            keys = {
                { '<leader>ul', '<Cmd>FzfLines<CR>', desc = 'Fzf lines in the buffer' },
                { '<leader>ur', '<Cmd>FzfFiles<CR>', desc = 'Fzf files in the current directory' },
                { '<leader>ug', '<Cmd>FzfGFiles<CR>', desc = 'Fzf files of the git repository' },
                { '<leader>us', '<Cmd>FzfGFiles?<CR>', desc = 'Fzf files of the git repository (untracked)' },
                { '<leader>uh', '<Cmd>FzfHistory<CR>', desc = 'Fzf files from the history' },
                { '<leader>b', '<Cmd>FzfBuffers<CR>', desc = 'Fzf buffers' },
                { '<leader>gp', ':<C-u>FzfGGrep<Space>', desc = 'Fzf grep in the git repository' },
                { '<leader><C-o>', '<Plug>(fzf-maps-n)', desc = 'Fzf normal mappings' },
                { '<leader><C-o>', '<Plug>(fzf-maps-x)', mode = 'x', desc = 'Fzf visual mappings' },
                { '<leader><C-o>', '<Plug>(fzf-maps-o)', mode = 'o', desc = 'Fzf operator mappings' },
                { '<C-x><C-f>', '<Plug>(fzf-complete-path)', mode = 'i', desc = 'Fzf complete path' },
                { '<C-x><C-l>', '<Plug>(fzf-complete-line)', mode = 'i', desc = 'Fzf complete line' },
            },
            config = function ()
                vim.api.nvim_create_user_command('FzfFiles',
                    'call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)',
                    { bang = true, nargs = '?', complete = 'dir' }
                )
                vim.api.nvim_create_user_command('FzfGGrep',
                    'call fzf#vim#grep(\'git grep --line-number -- \'.shellescape(<q-args>), 0, fzf#vim#with_preview({\'dir\': systemlist(\'git rev-parse --show-toplevel\')[0]}), <bang>0)',
                    { bang = true, nargs = '*' }
                )
            end,
        },
        'tpope/vim-obsession',
        'github/copilot.vim',
        {
            'ojroques/nvim-osc52',
            enabled = function ()
                return vim.fn.has('clipboard') == 0
            end,
            config = function ()
                local function copy(lines, _)
                    require('osc52').copy(table.concat(lines, '\n'))
                end

                local function paste()
                    return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
                end

                vim.g.clipboard = {
                    name = 'osc52',
                    copy = {['+'] = copy, ['*'] = copy},
                    paste = {['+'] = paste, ['*'] = paste},
                }
                -- Now the '+' register will copy to system clipboard using OSC52
            end,
        },

        -- Language support
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            config = function ()
                vim.o.foldmethod = 'expr'
                vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
            end,
            opts = {
                ensure_installed = { "vim", "vimdoc" },
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
            },
        },
        'nvim-treesitter/nvim-treesitter-textobjects',
        {
            'neoclide/coc.nvim',
            branch = 'release',
            config = function ()
                local opts = {silent = true, noremap = false, expr = true, replace_keycodes = false}
                vim.keymap.set('n', '<leader>ac', '<Plug>(coc-codeaction)')
                vim.keymap.set('n', '<leader>fx', '<Plug>(coc-fix-current)')
                vim.keymap.set('n', '<leader>if', '<Plug>(coc-diagnostic-info)')
                vim.keymap.set('n', '<leader>dn', ':<C-u>CocDiagnostics<CR>')
                vim.keymap.set('n', '<leader>fm', '<Plug>(coc-format)')
                vim.keymap.set('n', '<leader>nm', '<Plug>(coc-rename)')
                vim.keymap.set('n', '<leader>us', '<Plug>(coc-references)')
                vim.keymap.set('n', '<leader>dc', '<Plug>(coc-declaration)')
                vim.keymap.set('n', '<leader>ip', '<Plug>(coc-implementation)')
                vim.keymap.set('n', '<leader>rf', '<Plug>(coc-refactor)')
                vim.keymap.set('n', '<leader>ln', '<Plug>(coc-codelens-action)')
                vim.keymap.set('n', '<leader>im', ':<C-u>silent call CocAction("runCommand", "editor.action.organizeImport")<CR>', { nowait = true })
                vim.keymap.set('n', '<leader>?', ':call CocActionAsync("doHover")<CR>', { nowait = true })
                vim.keymap.set('n', '<C-w>u', '<Plug>(coc-float-jump)')
                vim.keymap.set('n', '<C-]>', 'CocHasProvider("definition") ? "<Plug>(coc-definition)" : "<C-]>"', opts)
                vim.keymap.set('n', '<C-w><C-]>', 'CocHasProvider("definition") ? ":call CocAction("jumpDefinition", "vsplit")<CR>" : "<C-w><C-]>"', opts)
                vim.keymap.set('i', '<CR>', 'coc#pum#visible() ? coc#_select_confirm() : "<C-g>u<CR><c-r>=coc#on_enter()<CR>"', opts)
                vim.g.coc_snippet_next = '<C-l>'
                vim.g.coc_snippet_prev = '<C-k>'

                local aug = vim.api.nvim_create_augroup('vimrc_coc_keymap', { clear = true })
                vim.api.nvim_create_autocmd('FileType', {
                    group = aug,
                    pattern = 'go',
                    callback = function ()
                        vim.keymap.set('n', '<leader>ts', ':<C-u>CocCommand go.test.toggle<CR>')
                    end
                })
            end
        },
        {
            'antoinemadec/coc-fzf',
            branch = 'release',
            dependencies = { 'junegunn/fzf' },
            config = function ()
                vim.keymap.set('n', '<leader>ou', ':<C-u>CocFzfList outline<cr>')
                vim.keymap.set('n', '<leader>oc', ':<C-u>CocFzfList commands<cr>')
                vim.keymap.set('n', '<leader>ol', ':<C-u>CocFzfList<cr>')
            end
        },
        {
            'vim-test/vim-test',
            config = function ()
                vim.g['test#strategy'] = 'neovim'
            end,
        },
        {
            'fatih/vim-go',
            lazy = true,
            ft = 'go',
            config = function ()
                vim.cmd([[
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
                let g:go_highlight_types = 1
                let g:go_highlight_operators = 1
                let g:go_highlight_build_constraints = 1
                ]])
            end,
        },
        {
            'buoto/gotests-vim',
            -- To install:
            -- go install github.com/cweill/gotests/...@latest
            enabled = function ()
                return vim.fn.executable('gotests') == 1
            end,
        },
        {
            'pangloss/vim-javascript',
            lazy = true,
            ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        },
        {
        'HerringtonDarkholme/yats.vim',
            lazy = true,
            ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        },
        {
        'maxmellon/vim-jsx-pretty',
            lazy = true,
            ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        },

        -- Other
        {
            'mikesmithgh/kitty-scrollback.nvim',
            lazy = true,
            cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
            event = { 'User KittyScrollbackLaunch' },
            version = '^3.0.0',
            config = function()
                require('kitty-scrollback').setup()
            end,
        },
    })
