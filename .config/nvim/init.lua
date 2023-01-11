vim.cmd('set runtimepath^=~/.vim runtimepath+=~/.vim/after')
vim.cmd('let &packpath = &runtimepath')

vim.cmd('au TextYankPost * silent! lua vim.highlight.on_yank()')

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

vim.opt.timeoutlen = 500

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
    { 'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
    },
    { 'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-telescope/telescope-fzf-native.nvim' },
        config = function()
            local telescope = require('telescope')
            telescope.setup({
                defaults = {
                    file_ignore_patterns = {
                        ".git/*", ".local/*", ".npm/*", ".rustup/*", ".cache/*"
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true
                    },
                },
            })

            telescope.load_extension('fzf')
            telescope.load_extension('noice')
        end
    },
    { 'williamboman/mason.nvim',
        config = true,
    },
    { 'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = { "rust_analyzer" },
                automatic_installation = true,
            })
        end
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
                                    codelldb_path, liblldb_path),
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
    -- Cmp Extras
    { 'hrsh7th/cmp-nvim-lsp' }, { 'hrsh7th/cmp-nvim-lua' }, { 'hrsh7th/cmp-nvim-lsp-signature-help' }, { 'hrsh7th/cmp-vsnip' }, { 'hrsh7th/cmp-path' }, { 'hrsh7th/cmp-buffer' }, { 'hrsh7th/vim-vsnip' },
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
    { 'mfussenegger/nvim-dap' },
    { 'rust-lang/rust.vim' },
    { 'voldikss/vim-floaterm', 
        -- Opens a terminal window in a floating window
        config = function()
            vim.cmd(":FloatermNew --name=myterm --height=0.8 --width=0.7 --autoclose=2 --silent bash <CR>") -- Silently open the terminal 
            vim.keymap.set('t', "<Esc>", "<C-\\><C-n>:q<CR>")
        end
    },
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
    },
    { 'folke/which-key.nvim',
        priority = 0, -- Load last so all modules are available
        config = function()
            local wk = require("which-key")
            local ts_builtin = require("telescope.builtin")
            local dap = require("dap")
            local noice = require('noice')
            wk.register(
                { 
                    f = { 
                        name = "Telescope Find",
                        f = { ts_builtin.find_files, "Find File" },
                        F = { function() ts_builtin.find_files({ cwd = "~/." }) end, "Find File in Home" },
                        s = { ts_builtin.current_buffer_fuzzy_find, "Find in Current Buffer" },
                        h = { ts_builtin.help_tags, "Find Help" },
                        b = { ts_builtin.buffers, "Find Buffer" },
                        o = { ts_builtin.vim_options, "Find Vim Option" },
                        m = { ts_builtin.man_pages, "Find Man Page" },
                        i = { ts_builtin.lsp_implementations, "Find Implementations" },
                        d = { ts_builtin.lsp_definitions, "Find Definitions" },
                        r = { ts_builtin.lsp_references, "Find References" },
                    },
                    d = {
                        name = "Debug",
                        b = { dap.toggle_breakpoint, "Toggle Breakpoint" },
                        c = { dap.continue, "Continue" },
                        d = { dap.step_over, "Step Over" },
                        i = { dap.step_into, "Step Into" },
                        r = { dap.repl.open, "Open Repl" },
                    },
                    t = {
                        name = "Terminal",
                        t = { "<cmd>FloatermToggle myterm<CR>", "Open Terminal" },
                        n = { "<cmd>FloatermNew --height=0.8 --width=0.7 --autoclose=2 --disposable bash<CR>", "Open Scratch Terminal" },
                        b = { function()
                                  vim.cmd(string.format(":FloatermNew --height=0.8 --width=0.7 --autoclose=0 --disposable lynx -vikeys %s", vim.fn.getreg('"')))
                              end, 
                              "Open Register Content In Elinks" },
                    },
                    g = {
                        name = "Git",
                        s = { ts_builtin.git_status, "Git Status" }
                    },
                    r = {
                        -- TODO: Make this adapt to the currently loaded file type  
                        name = "Run",
                        -- TODO: Change this to open a new terminal that runs cargo run
                        r = { "<CMD>FloatermNew --height=0.8 --width=0.7 --autoclose=0 --disposable cargo run<CR>", "Run" },
                    },
                    n = {
                        name = "Messages",
                        l = { function() noice.cmd("last") end, "Last Message" },
                        h = { function() noice.cmd("history") end, "History" },
                    },
                },
                { prefix = "<leader>" }
            )
	    end
    },
}
)

