-- Bootstrap lazy.nvim
local plug_dir = vim.fn.stdpath("data") .. "/lazy"
local lazypath = plug_dir .. "/lazy.nvim"
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
    --------------
    --  Visual  --
    --------------
    {
        'sainnhe/edge',
        lazy = false,
        priority = 1000,
        init = function ()
            vim.g.edge_better_performance = 1
            vim.g.edge_transparent_background = 1
            vim.cmd.colorscheme("edge")
            if vim.env.THEME_MODE == 'light' then
                vim.opt.background = 'light'
            else
                vim.opt.background = 'dark'
                -- Ensure THEME_MODE is set
                vim.env.THEME_MODE = 'dark'
            end
        end
    },
    'lilydjwg/colorizer',
    {
        'itchyny/lightline.vim',
        dependencies = { 'sainnhe/edge' },
        init = function ()
            vim.o.showmode = false
            vim.g.lightline = {
                colorscheme = 'one',
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

            -- Set timer to update theme
            local timer = vim.loop.new_timer()
            timer:start(2000, 2000, vim.schedule_wrap(function ()
                -- Switch theme based on time
                local hour = tonumber(os.date('%H'))
                local theme = 'dark'
                if hour >= 7 and hour < 20 then
                    theme = 'light'
                else
                    theme = 'dark'
                end

                -- Update theme if changed
                if vim.env.THEME_MODE ~= theme then
                    vim.env.THEME_MODE = theme
                    vim.o.background = theme

                    vim.cmd('source ' .. plug_dir .. '/lightline.vim/autoload/lightline/colorscheme/one.vim')
                    vim.fn['lightline#colorscheme']()
                    vim.fn['lightline#update']()
                end
            end))
        end,
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter'},
        lazy = true,
        ft = 'markdown',
    },

    ------------------------
    --  Language support  --
    ------------------------
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        main = "nvim-treesitter.configs",
        init = function ()
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
        enabled = false,
        branch = 'release',
        init = function ()
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
        'neovim/nvim-lspconfig',
        init = function ()
            local aug = vim.api.nvim_create_augroup('vimrc_lspconfig', { clear = true })

            vim.api.nvim_create_autocmd('LspAttach', {
                group = aug,
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client.supports_method('textDocument/codeAction') then
                        vim.keymap.set('n', '<leader>ac', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
                    end
                    if client.supports_method('textDocument/rename') then
                        vim.keymap.set('n', '<leader>nm', '<Cmd>lua vim.lsp.buf.rename()<CR>')
                    end
                    if client.supports_method('textDocument/references') then
                        vim.keymap.set('n', '<leader>us', '<Cmd>lua vim.lsp.buf.references()<CR>')
                    end
                    if client.supports_method('textDocument/implementation') then
                        vim.keymap.set('n', '<leader>ip', '<Cmd>lua vim.lsp.buf.implementation()<CR>')
                    end
                    if client.supports_method('textDocument/codeLens') then
                        vim.keymap.set('n', '<leader>ln', '<Cmd>lua vim.lsp.codelens.run()<CR>')
                    end
                    if client.supports_method('textDocument/formatting') then
                        -- Format the current buffer on save
                        vim.api.nvim_create_autocmd('BufWritePre', {
                            buffer = args.buf,
                            callback = function()
                                vim.lsp.buf.format({bufnr = args.buf, id = client.id})
                            end,
                        })
                    end
                end,
            })

            local servers = {
                { 'gopls' },
                {
                    'pyright',
                    config_func = function ()
                        vim.keymap.set('n', '<leader>im', ':<C-u>PyrightOrganizeImports<CR>')
                    end
                },
                { 'ts_ls' },
            }

            local lsp = require('lspconfig')
            for _, server in pairs(servers) do
                local config = lsp[server[1]]
                -- use settings.cmd then fall back to document_config.default_config.cmd
                local bin_path = server.cmd and server.cmd[1] or config.document_config.default_config.cmd[1]

                -- Only setup a language server if we have the binary available
                if (vim.fn.executable(bin_path)) then
                    local setup_config = {}

                    -- Add custom config if available
                    for k, v in pairs(server) do
                        if k == 'config_func' then
                            v()
                        else
                            setup_config[k] = v
                        end
                    end

                    config.setup(setup_config)
                end
            end
        end
    },
    {
        'antoinemadec/coc-fzf',
        enabled = false,
        branch = 'release',
        dependencies = { 'junegunn/fzf' },
        init = function ()
            vim.keymap.set('n', '<leader>ou', ':<C-u>CocFzfList outline<cr>')
            vim.keymap.set('n', '<leader>oc', ':<C-u>CocFzfList commands<cr>')
            vim.keymap.set('n', '<leader>ol', ':<C-u>CocFzfList<cr>')
        end
    },
    {
        'vim-test/vim-test',
        init = function ()
            vim.g['test#strategy'] = 'neovim'
        end,
    },
    {
        'fatih/vim-go',
        enabled = false,
        lazy = true,
        ft = 'go',
        init = function ()
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

    -----------------------
    --  Auto completion  --
    -----------------------
    {
        'hrsh7th/nvim-cmp',
        main = 'cmp',
        init = function (cmp)
            local cmp = require('cmp')

            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                },
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                }),
                matching = { disallow_symbol_nonprefix_matching = false },
            })
        end,
        opts = function (cmp, tb)
            local cmp = require('cmp')

            tb.snippet = {
                expand = function(args)
                    vim.fn['UltiSnips#Anon'](args.body)
                end,
            }
            tb.mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            })
            tb.sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'ultisnips' },
            }, {
                { name = 'buffer' },
            })
            tb.performance = {
                max_view_entries = 20,
            }
        end,
    },
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'quangnguyen30192/cmp-nvim-ultisnips',

    -------------
    --  Other  --
    -------------
    {
        'mikesmithgh/kitty-scrollback.nvim',
        lazy = true,
        cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
        event = { 'User KittyScrollbackLaunch' },
        version = '^3.0.0',
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
        init = function ()
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
        init = function ()
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
        init = function ()
            vim.g.gitgutter_map_keys = 0
            vim.o.updatetime = 1000
            vim.keymap.set('n', '<leader>hN', '<Plug>(GitGutterPrevHunk)')
            vim.keymap.set('n', '<leader>hn', '<Plug>(GitGutterNextHunk)')
            vim.keymap.set('n', '<leader>hs', '<Plug>(GitGutterStageHunk)')
            vim.keymap.set('n', '<leader>hu', '<Plug>(GitGutterUndoHunk)')
            vim.keymap.set('n', '<leader>hp', '<Plug>(GitGutterPreviewHunk)')
        end,
    },
    'dkarter/bullets.vim',
    {
        'previm/previm',
        init = function ()
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
            vim.api.nvim_create_user_command('FzfFiles',
            'call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)',
            { bang = true, nargs = '?', complete = 'dir' }
            )
            vim.api.nvim_create_user_command('FzfGGrep',
            'call fzf#vim#grep(\'git grep --line-number -- \'.shellescape(<q-args>), 0, fzf#vim#with_preview({\'dir\': systemlist(\'git rev-parse --show-toplevel\')[0]}), <bang>0)',
            { bang = true, nargs = '*' }
            )
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
    },
    'tpope/vim-obsession',
    {
        'github/copilot.vim',
        init = function ()
            vim.g.copilot_filetypes = {
                text = false,
            }
        end,
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "github/copilot.vim" },
            { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
        },
        build = "make tiktoken", -- Only on MacOS or Linux
        opts = {},
    },
    {
        'ojroques/nvim-osc52',
        enabled = function ()
            return vim.env.SSH_OR_CONTAINER == '1'
        end,
        init = function ()
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
})
