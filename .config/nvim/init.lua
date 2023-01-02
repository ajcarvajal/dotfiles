vim.cmd('set runtimepath^=~/.vim runtimepath+=~/.vim/after')
vim.cmd('let &packpath = &runtimepath')

vim.cmd('au TextYankPost * silent! lua vim.highlight.on_yank()')
--[[
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = vim.highlight.on_yank,
})
]]

-- Non plugin keymaps
vim.keymap.set('n', '`', ':noh<CR>', {})

-- command line
vim.opt.cmdheight = 0  -- hide command line when inactive
vim.cmd('au InsertLeave * silent! redraw')  -- workaround for status line disappearing

-- tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- colorscheme
vim.cmd('colorscheme habamax')

-- persistant undo
vim.cmd('set undofile')

-- automatically change dir to project root on file change
require('autochdir')

-- LSP Diagnostics
local sign = function(opts)
    vim.fn.sign_define(opts.name, { texth1 = optsname, text = opts.txt, numhl = '' })
end

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = false,
    underline = true,
    serverity_sort = false,
    float = {
        boarder = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    }
})

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 300)

-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error 
-- Show inlay_hints more frequently 
vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])


-- Plugins
-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)
vim.keymap.set('n', '<leader>p', ':Lazy<CR>')

-- Plugin setup
require("lazy").setup(
{
    { 'nvim-tree/nvim-web-devicons',
        -- Icon support for various plugins
        config = true
    },
    { 'feline-nvim/feline.nvim',
        -- Fancy status line
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            vim.opt.termguicolors = true
        end
    },
    { 'ibhagwan/fzf-lua',
        config = function()
            fzf = require('fzf-lua')
            fzf.setup({ 
                files = { 
                    fd_opts = "--color=never --type f --hidden --follow"
                }})
            vim.keymap.set('n', '<leader>ff', '<cmd>lua fzf.files()<CR>')
            vim.keymap.set('n', '<leader>fF', '<cmd>lua fzf.files({ cwd = "~" })<CR>')
            vim.keymap.set('n', '<leader>fw', '<cmd>lua fzf.files({ cwd = "mnt/d/repo/" })<CR>')
            vim.keymap.set('n', '<leader>fs', '<cmd>lua fzf.grep_cword()<CR>')
            vim.keymap.set('n', '<leader>fS', '<cmd>lua fzf.live_grep_native()<CR>')
            vim.keymap.set('n', '<leader>fj', '<cmd>lua fzf.grep_curbuf()<CR>')
        end
    },
    { 'williamboman/mason.nvim',
        config = true
    },
    { 'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
    },
    { 'neovim/nvim-lspconfig' },
    { 'nvim-lua/plenary.nvim' },
    { 'simrat39/rust-tools.nvim',
        dependencies = { 
            'neovim/nvim-lspconfig', 
            'williamboman/mason-lspconfig.nvim',
            'nvim-lua/plenary.nvim',
            'mfussenegger/nvim-dap',
            'rust-lang/rust.vim' },
        config = function()
            local rt = require('rust-tools')
            local extension_path = vim.env.HOME .. '/.local/share/nvim/mason/packages/codelldb/extension/'
            local codelldb_path = extension_path .. 'adapter/codelldb'
            local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'

            rt.setup({
                server = {
                    on_attach = function(_, bufnr)
                        vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
                        vim.keymap.set("n", "<leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
                    end,

                    settings = {
                        ["rust-analyzer"] = {
                            inlayHints = { locationLinks = false },
                        }
                    },
                },
                dap = {
                    adapter = require('rust-tools.dap').get_codelldb_adapter(
                    codelldb_path, liblldb_path)
                },

                hover_actions = {
                    auto_focus = true,
                },
            })
            vim.cmd('let g:rustfmt_autosave = 1')
        end
    },
    { 'hrsh7th/nvim-cmp',
        config = function()
            local cmp = require('cmp')
            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end
                },
                mapping = {
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
                    ['<Tab>'] = cmp.mapping.select_next_item(),
                    ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.close(),
                    ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true, }),
                },
                sources = {
                    { name = 'path' },                              -- file paths
                    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
                    { name = 'nvim_lsp_signature_help' },           -- display function signatures with current parameter emphasized
                    { name = 'nvim_lua', keyword_length = 2 },      -- complete neovim's Lua runtime API such vim.lsp.*
                    { name = 'buffer', keyword_length = 2 },        -- source current buffer
                    { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
                    { name = 'calc' }                               -- source for math calculation
                },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            formatting = {
                fields = {'menu', 'abbr', 'kind'},
                format = function(entry, item)
                    local menu_icon = {
                        nvim_lsp = 'λ',
                        vsnip = '⋗',
                        buffer = 'Ω',
                        path = '🖫',
                    }
                    item.menu = menu_icon[entry.source.name]
                    return item
                end
            },
        })
        end
    },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-nvim-lua' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    { 'hrsh7th/cmp-vsnip' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/vim-vsnip' },
    { 'nvim-treesitter/nvim-treesitter', 
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = { "lua", "rust", "toml" },
                auto_install = true,
                highlight = {
                    enable = true,
                    addition_vim_regex_highlighting = false
                },
                ident = { enable = true },
                rainbow = {
                    enable = true,
                    extended_mode = true,
                    max_file_lines = nil,
                },
            })
            vim.wo.foldmethod = 'expr'
            vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
            vim.wo.foldlevel = 1
        end
    },
    { 'mfussenegger/nvim-dap',
        config = function()
            vim.keymap.set('n', '<leader>db', '<cmd> lua require("dap").toggle_breakpoint()<CR>')
            vim.keymap.set('n', '<leader>dc', '<cmd> lua require("dap").continue()<CR>')
            vim.keymap.set('n', '<leader>dd', '<cmd> lua require("dap").step_over()<CR>')
            vim.keymap.set('n', '<leader>di', '<cmd> lua require("dap").step_into()<CR>')
            vim.keymap.set('n', '<leader>dr', '<cmd> lua require("dap").repl.open()<CR>')
	end	
    },
    { 'rust-lang/rust.vim' },
    { 'voldikss/vim-floaterm', 
        -- Opens a terminal window in a floating window
        config = function()
            vim.cmd(":FloatermNew --name=myterm --height=0.8 --width=0.7 --autoclose=2 --silent bash <CR>") -- Silently open the terminal 
            vim.keymap.set('n', "<leader>t", ":FloatermToggle myterm<CR>")
            vim.keymap.set('t', "<Esc>", "<C-\\><C-n>:q<CR>")
        end
    },
    --[[
    { 'AckslD/messages.nvim',
        -- Output results from the command line to a floating window
        config = function()
            require('messages').setup(
            {
                command_name = "F",
                buffer_opts = function(lines)
                    local width = vim.api.nvim_get_option("columns")
                    local height = vim.api.nvim_get_option("lines")
                    local win_width = math.ceil(width * 0.8)
                    local win_height = math.ceil(height * 0.8 - 4)
                    return {
                        relative = 'editor',
                        width = win_width,
                        height = win_height,
                       row = math.ceil((height - win_height) / 2 - 1),
                       col = math.ceil((width - win_width) / 2),
                        style = 'minimal',
                        border = 'shadow',
                        zindex = 1,
                    }
                end,

                post_open_float = function(winnr)
                    vim.cmd("nnoremap <buffer> <Esc> <C-\\><C-n>:q<CR>")
                end,
            })
        end,
    },
    ]]
    { 'MunifTanjim/nui.nvim' },
    { 'rcarriga/nvim-notify' },
    { 'folke/noice.nvim',
        dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' },
        config = function()
            require('noice').setup({
                presets = {
                    bottom_search = true,
                    command_palette = true,
                    long_message_to_split = true,
                    inc_rename = false,
                    lsp_doc_border = false,
                },
            })
        end
    }
}
)

