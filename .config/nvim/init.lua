vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.linebreak = true

-- vim.opt.showcmd = false
-- suppressing deprecation warning (delete in future for debugging)
---@diagnostic disable-next-line: duplicate-set-field
vim.deprecate = function() end

-- vim.opt.textwidth = 100
vim.opt.fillchars:append 'diff:╱'
vim.keymap.del('n', 'grn')
vim.keymap.del('n', 'gra')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'gri')

vim.opt.tabstop = 4 -- A TAB character looks like 4 spaces
vim.opt.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.opt.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.opt.shiftwidth = 4 -- Number of spaces inserted when indenting
vim.opt.iskeyword:remove ':'

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    if vim.bo.filetype ~= 'dashboard' then
      vim.opt.showtabline = 2
    end
  end,
})

-- prevents a comment from being inserted when adding a newline above/below an existing comment
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    vim.opt_local.formatoptions:remove { 'r', 'o' }
  end,
})

-- vim.api.nvim_create_autocmd({ 'TermEnter' }, {
--   callback = function()
--     for _, buffers in ipairs(vim.fn.getbufinfo()) do
--       local filetype = vim.api.nvim_buf_get_option(buffers.bufnr, 'filetype')
--       if filetype == 'toggleterm' then
--         vim.api.nvim_create_autocmd({ 'BufWriteCmd', 'FileWriteCmd', 'FileAppendCmd' }, {
--           buffer = buffers.bufnr,
--           command = 'q!',
--         })
--       end
--     end
--   end,
-- })

local my_augroup = vim.api.nvim_create_augroup('mygroup', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'tex', 'markdown' },
  command = 'setlocal spell spelllang=en_us | set spellcapcheck= | syntax spell toplevel ',
  group = my_augroup,
})

-- vim.api.nvim_create_autocmd('VimEnter', {
--   group = vim.api.nvim_create_augroup('restore_session', { clear = true }),
--   callback = function()
--     if vim.fn.getcwd() ~= vim.env.HOME then
--       require('persistence').load()
--     end
--   end,
--   nested = true,
-- })

-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { 'tex', 'markdown' },
--   callback = function()
--     vim.opt.iskeyword:append '\\'
--   end,
--   group = my_augroup,
-- })
vim.cmd [[
augroup filetypedetect
  au! BufRead,BufNewFile *.mpc                setfiletype python
augroup END
]]

-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'qf',
--   callback = function(event)
--     local opts = { buffer = event.buf, silent = true }
--     vim.keymap.set('n', '<C-n>', '<cmd>cn | wincmd p<CR>', opts)
--     vim.keymap.set('n', '<C-S-n>', '<cmd>cN | wincmd p<CR>', opts)
--   end,
-- })

-- enabling cursor blinking
-- vim.opt.guicursor = table.concat({
--   'r:hor50-Cursor/lCursor-blinkwait100-blinkon100-blinkoff100',
--   'n-v-c:block-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100',
--   'i-ci:ver25-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100',
-- }, ',')

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true
-- used to hide duplicate search count when using lualine

-- enable spellcheck by default
vim.opt.spelllang = 'en_us'
-- vim.opt.spell = true
-- vim.g.tex_comment_nospell = 1

-- vim.opt.pumblend = 0
-- vim.opt.winblend = 0
-- vim.opt.pumheight = 100

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true
-- vim.api.nvim_create_autocmd('InsertEnter', { command = [[set norelativenumber]] })
-- vim.api.nvim_create_autocmd('InsertLeave', { command = [[set relativenumber]] })

vim.api.nvim_create_autocmd('InsertEnter', {
  callback = function()
    local filetype = vim.bo[0].filetype
    if filetype ~= 'neo-tree-popup' and filetype ~= 'neo-tree' then
      -- if not string.find(buf_name, 'neo-tree') then
      vim.opt.relativenumber = false
    end
  end,
})

vim.api.nvim_create_autocmd('InsertLeave', {
  callback = function()
    local filetype = vim.bo[0].filetype
    if filetype ~= 'neo-tree-popup' and filetype ~= 'neo-tree' then
      vim.opt.relativenumber = true
    end
  end,
})

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'
vim.opt.mousemoveevent = true
vim.api.nvim_set_keymap('n', '<c-ScrollWheelUp>', '', { noremap = true })
vim.api.nvim_set_keymap('n', '<c-ScrollWheelDown>', '', { noremap = true })

vim.cmd [[
  aunmenu PopUp.How-to\ disable\ mouse
  aunmenu PopUp.-1-

]]
vim.keymap.set('n', '<delete>', '')
-- vim.keymap.set('n', '<delete>', '')
-- vim.keymap.set('i', '<c-s-w>', 'X<esc>lbce')
-- Don show the mode, since it's already in the status line

vim.keymap.set('n', '<c-ScrollWheelUp>', '')
vim.keymap.set('n', '<c-ScrollWheelDown>', '')
-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true
vim.opt.breakindentopt = 'list:-1'
vim.opt.smartindent = true

-- Save undo history
vim.opt.autoread = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 0

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- -- shows a margin at 80 characters
-- vim.opt.colorcolumn = "100"

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.listchars = { tab = '→ ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
-- vim.opt.cursorline = true
-- vim.opt.cursorlineopt = 'screenline'

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- used to keep visual selection while indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

vim.keymap.set({ 'n', 't', 'c' }, '<C-S-N>', '<C-p>')
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
-- primeagen's keymaps
vim.keymap.set('c', 'qq', 'qa')
-- vim.keymap.set('c', 'q', 'qa')

-- vim.keymap.set('n', '<C-S-J>', ':m .+1<CR>==')
-- vim.keymap.set('n', '<C-S-K>', ':m .-2<CR>==')

vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')

-- vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
-- vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
-- vim.keymap.set({ 'v' }, '<C-S-K>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
-- vim.keymap.set({ 'v' }, '<C-S-J>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })

vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join line' })
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = 'Paste' })

-- dont need these since i'm always using a unified clipboard
-- if vim.loop.os_uname().sysname == 'Darwin' then
--   vim.keymap.set({ 'n', 'v' }, '<leader>y', [["*y]], { desc = 'Yank pattern into system clipboard' })
--   vim.keymap.set('n', '<leader>Y', [["*Y]], { desc = 'Yank line into system clipboard' })
--   vim.keymap.set('n', '<leader>p', [["*p]], { desc = 'Paste from system clipboard' })
-- else
--   vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = 'Yank pattern into global clipboard' })
--   vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = 'Yank line into global clipboard' })
--   vim.keymap.set('n', '<leader>p', [["+p]], { desc = 'Paste from system clipboard' })
-- end

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- vim.keymap.set('i', 'jj', '<Esc>')

-- Diagnostic keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })

vim.diagnostic.config {
  virtual_text = true,
  float = {
    header = '',
    border = 'rounded',
    focusable = false,
  },

  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = ' ',
    },
    -- numhl = {
    --   [vim.diagnostic.severity.WARN] = 'WarningMsg',
    --   [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
    --   [vim.diagnostic.severity.INFO] = 'Character',
    --   [vim.diagnostic.severity.HINT] = 'MoreMsg',
    -- },
  },
}

vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end)
vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end)
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Show errors' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open quickfix' })
-- vim.keymap.set('n', '<leader>Q', vim.cmd.cclose)

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- fuck this macro key
vim.api.nvim_set_keymap('n', 'Q', 'q', { noremap = true })
vim.api.nvim_set_keymap('n', 'q', '', { noremap = true })

vim.api.nvim_create_user_command('WQ', 'wq', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Qa', 'qa', {})
vim.api.nvim_create_user_command('Q', 'q', {})
vim.api.nvim_create_user_command('QQ', 'qq', {})
-- vim.api.nvim_create_user_command('qq', 'qa', {})

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus below' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus above' })

vim.keymap.set('n', '<C-w>s', '<C-w>v', { desc = 'Split vertically' })
vim.keymap.set('n', '<C-w>S', '<C-w>s', { desc = 'Split horizontally' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
-- vim.api.nvim_create_autocmd('BufReadPre', {

vim.api.nvim_create_autocmd('VimLeavePre', {
  -- desc = 'Highlight when yanking (copying) text',
  -- group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    local bufs = vim.api.nvim_list_bufs()
    -- local current_buf = vim.api.nvim_get_current_buf()
    for _, i in ipairs(bufs) do
      -- local filetype = vim.bo[i].filetype
      local buf_name = vim.fn.bufname(i)
      -- local buf_type = vim.fn.getwininfo(i)
      -- print(buf_name)
      -- print(buf_type)
      -- print(filetype)
      -- if filetype == '' then
      --   vim.api.nvim_buf_delete(i, {})
      -- end
      if buf_name == '' then
        vim.api.nvim_buf_delete(i, {})
      end

      -- this was triggering a strange message when exiting after opening a toggleterm window
      -- if string.find(buf_name, 'term://') then
      --   vim.api.nvim_buf_delete(i, { slent = true })
      -- end
      if string.find(buf_name, '/tmp/nvim.alessandro/') then
        vim.api.nvim_buf_delete(i, {})
      end
      -- if string.find(vim.fs.basename(buf_name), '0')  then
      --   vim.api.nvim_buf_delete(i, {})
      -- end
      -- if filetype == '' then
      --   vim.api.nvim_buf_delete(i, {})
      -- end
    end
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  {
    'numToStr/Comment.nvim',
    lazy = false,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('Comment').setup {
        ignore = '^$',
        toggler = {
          line = 'gcc', ---Line-comment toggle keymap
          block = 'gcC', ---Block-comment toggle keymap
        },
        opleader = {
          line = 'gc', ---Line-comment keymap
          block = 'gC', ---Block-comment keymap
        },
      }
      vim.keymap.set('n', '<leader>;', function()
        return vim.v.count == 0 and '<Plug>(comment_toggle_linewise_current)' or '<Plug>(comment_toggle_linewise_count)'
      end, { expr = true, desc = 'Toggle comment' })
      vim.keymap.set('x', '<leader>;', '<Plug>(comment_toggle_linewise_visual)', { desc = 'Toggle comment' })
    end,
  },

  --
  { 'nvim-tree/nvim-web-devicons', opts = { true } },

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    -- event = 'VeryLazy',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'saghen/blink.cmp',
      'ibhagwan/fzf-lua',
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
          end

          local fzf = require 'fzf-lua'
          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', fzf.lsp_definitions, 'Goto definition')

          -- -- Find references for the word under your cursor.
          map('gr', fzf.lsp_references, 'Goto references')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', fzf.lsp_implementations, 'Goto implementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', fzf.lsp_typedefs, 'Type definition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>js', function()
            -- fzf.lsp_document_symbols { show_line = true, symbols = { 'function', 'variable', 'class' } }
            fzf.lsp_document_symbols { show_line = true }
          end, 'Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ps', fzf.lsp_live_workspace_symbols, 'Project symbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, 'Rename')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<c-.>', function()
            fzf.lsp_code_actions {
              winopts = {
                -- relative = 'cursor',
                width = 0.8,
                height = 0.8,
                wrap = true,
                -- row = 1,
                preview = { layout = 'vertical', vertical = 'up:70%' },
              },
            }
          end, 'Code action')

          vim.keymap.set('n', 'K', function()
            if vim.bo.filetype == 'rust' then
              vim.cmd.RustLsp { 'hover', 'actions' }
            else
              vim.lsp.buf.hover { border = 'rounded' }
            end
          end, { buffer = event.buf, silent = true, desc = 'hover info' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, 'Goto declaration')

          map('<leader>td', function()
            vim.diagnostic.enable(not vim.diagnostic.is_enabled())
          end, 'Diagnostics')

          -- map('<leader>dd', function()
          --   vim.diagnostic.open_float(nil, { focus = false, scope = 'cursor' })
          --   -- vim.diagnostic.enable(not vim.diagnostic.is_enabled())
          -- end, 'Line diagnostics')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            -- if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'Inlay hints')
            -- enabling inlay hints by default
            vim.lsp.inlay_hint.enable()
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        clangd = {
          -- keys = {
          --   { '<A-o>', ':LspClangdSwitchSourceHeader<CR>' },
          -- },
          filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto', 'hpp' },
          -- capabilities = capabilities,
          cmd = { 'clangd', '--background-index', '--clang-tidy', '--query-driver=/usr/bin/c++' },
        },

        black = {},
        pyright = {},
        shfmt = {},
        codelldb = {},

        ltex_plus = {
          filetypes = { 'tex', 'md', 'bib' },
          settings = {
            ltex = {
              -- enabled = { "bibtex", "gitcommit", "markdown", "org", "tex", "restructuredtext", "rsweave", "latex", "quarto", "rmd", "context", "html", "xhtml", "mail" },     -- filetypes = { 'tex', 'md' },
              language = 'en-US',
              disabledRules = {
                ['en-US'] = {
                  'ARROWS',
                  'A_BIT',
                  'ON_COMPOUNDS',
                  'MORFOLOGIK_RULE_EN_US',
                  'WHITESPACE_RULE',
                  'CONSECUTIVE_SPACES',
                  'SENTENCE_WHITESPACE',
                  'COMMA_PARENTHESIS_WHITESPACE',
                },
              },
            },
          },
        },

        texlab = {
          filetypes = { 'tex', 'plaintex', 'bib' },
          settings = {
            texlab = {
              -- bibtexFormatter = 'bibtex-tidy',
              diagnostics = {
                -- allowedPatterns = { 'a^', '$-', '-$' }, -- Regex that does not match anything as texlab errors are obnoxious and incorrect for my LaTeX files
                ignoredPatterns = {
                  'Overfull',
                  'Underfull',
                  'Package hyperref Warning',
                  'Float too large for page',
                  'contains only floats',
                  'Unused entry',
                },
              },
            },
          },
        },

        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              diagnostics = {
                globals = { 'vim' },
              },
              completion = {
                callSnippet = 'Replace',
              },

              --       -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              --       -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      -- require('mason').setup()
      ---@type MasonLspconfigSettings
      ---@diagnostic disable-next-line: missing-fields
      require('mason-lspconfig').setup {

        automatic_enable = vim.tbl_keys(servers or {}),
      }

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
        'bash-language-server',
        'bibtex-tidy',
        'markdownlint',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      for server_name, config in pairs(servers) do
        vim.lsp.config(server_name, config)
      end

      -- vim.api.nvim_create_autocmd({ 'FileType' }, {
      --   pattern = { 'cpp', 'c', 'hpp', 'h', 'cuda' },
      --   callback = function()
      --   end,
      -- })
    end,
  },
  { -- You can easily change to a different colorscheme.
    'Mofiqul/dracula.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.

    -- enabled = false,
    config = function()
      local dracula = require 'dracula'
      local colors = dracula.colors()
      ---@diagnostic disable-next-line: missing-fields
      dracula.setup {
        -- overrides the default highlights with table see `:h synIDattr`
        -- transparent_bg = true, -- default false
        overrides = {
          BufferLineBufferSelected = {
            italic = false,
            -- bold = false,
            -- fg = colors['red'],
            -- bg = colors['red'],
          },
          BufferLineIndicatorSelected = {
            italic = false,
            -- fg = colors['green'],
            -- bg = colors['red'],
          },
          BufferLineSeparator = {
            italic = false,
            fg = colors['black'],
            -- fg = colors['green'],
            bg = colors['menu'],
          },
          BufferLineFill = {
            italic = false,
            fg = colors['red'],
            bg = colors['black'],
          },
        },
      }

      vim.cmd.colorscheme 'dracula'

      -- vim.cmd.hi('NormalFloat  guifg=none guibg=' .. colors['menu'])
      -- vim.cmd.hi 'StatusLine  guibg=none'
      -- for dashboard
      vim.cmd.hi('IconColor guifg=' .. colors.purple)
      vim.cmd.hi('KeyColor guifg=' .. colors.orange)

      vim.cmd.hi('TabLineSel  guibg=' .. colors.comment) -- control the underline for the bufferline tab
      vim.cmd.hi('StatusLine  guibg=' .. colors.selection)
      vim.cmd.hi('FloatBorder  guifg= ' .. colors.comment)

      vim.cmd.hi('LspReferenceWrite  guifg=none guibg=' .. colors.selection)
      vim.cmd.hi('LspReferenceRead   guifg=none guibg=' .. colors.selection)
      vim.cmd.hi('LspReferenceText   guifg=none guibg=' .. colors.selection)

      -- vim.cmd.hi 'LspReferenceWrite    gui=underline guifg=none guibg=none'
      -- vim.cmd.hi 'LspReferenceRead  gui=underline guifg=none guibg=none'
      -- vim.cmd.hi 'LspReferenceText     gui=underline guifg=none guibg=none'

      -- vim.cmd.hi('TreesitterContextBottom gui=underline guisp=' .. colors['selection'])
      -- vim.cmd.hi('TreesitterContextLineNumberBottom gui=underline guisp=' .. colors[])

      vim.cmd.hi('MatchParen gui=none guibg=' .. colors.selection .. ' guifg=none')
      vim.cmd.hi('CurSearch gui=underline guibg=' .. colors.selection .. ' guifg=none')
      vim.cmd.hi('Search guibg=' .. colors.selection .. ' guifg=none')

      -- vim.cmd.hi('WhichKeyBorder  guifg='..colors.red)
      -- vim.cmd.hi('WhichKey guifg=' .. colors.bright_blue)
      -- vim.cmd.hi('WhichKeyDesc guifg=' .. colors.fg)
      -- vim.cmd.hi('WhichKeyGroup guifg=' .. colors.fg)

      -- mode-specific cursor colors
      vim.cmd.hi('CursorPurp  gui=none guifg=' .. colors.purple .. ' guibg=' .. colors.purple)
      vim.cmd.hi('CursorPink  gui=none guifg=' .. colors.pink .. ' guibg=' .. colors.pink)
      vim.cmd.hi('CursorFg gui=none guifg=' .. colors.fg .. ' guibg=' .. colors.fg)
      vim.cmd.hi('CursorCyan gui=none guifg=' .. colors.cyan .. ' guibg=' .. colors.cyan)
      vim.cmd.hi('CursorOrange gui=none guifg=' .. colors.orange .. ' guibg=' .. colors.orange)
      vim.cmd.hi('CursorRed gui=none guifg=' .. colors.red .. ' guibg=' .. colors.red)

      vim.api.nvim_set_hl(0, 'DiffAdd', { bg = '#20303b' })
      vim.api.nvim_set_hl(0, 'DiffDelete', { bg = '#37222c' })
      vim.api.nvim_set_hl(0, 'DiffChange', { bg = '#1f2231' })
      vim.api.nvim_set_hl(0, 'DiffText', { bg = '#394b70' })

      vim.opt.guicursor = table.concat({
        'r:hor50-CursorRed/lCursorRed-blinkwait100-blinkon100-blinkoff100',
        'n:block-CursorPurp/lCursorPurp-blinkwait1000-blinkon100-blinkoff100',
        'c:block-CursorOrange/lCursorOrange-blinkwait1000-blinkon100-blinkoff100',
        'ci:ver25-CursorOrange/lCursorOrange-blinkwait1000-blinkon100-blinkoff100',
        'v:block-CursorCyan/lCursorCyan-blinkwait1000-blinkon100-blinkoff100',
        'i:ver25-CursorFg/lCursorFg-blinkwait1000-blinkon100-blinkoff100',
        't:block-CursorPink/lCursorPink-blinkwait1000-blinkon100-blinkoff100',
      }, ',')

      -- vim.cmd.hi('DiagnosticFloatingError guibg=' .. colors['menu'])
      -- vim.cmd.hi('DiagnosticError guibg=' .. colors['menu'])
      -- vim.cmd.hi('DiagnosticVirtualTextError guibg=' .. colors['menu'])
    end,
  },
  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    -- enabled = false,
    opts = {
      signs = false,
      keywords = {
        FIX = {
          icon = ' ', -- icon used for the sign, and in search results
          color = 'error', -- can be a hex color, or a named color (see below)
          alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        -- TODO = { icon = ' ', color = 'info' },
        -- HACK = { icon = ' ', color = 'warning' },
        -- WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
        -- PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
        -- NOTE = { icon = ' ',  alt = { 'INFO' } },
        -- TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
      },
      -- colors = {
      --   error = { 'DiagnosticError', 'ErrorMsg', '#DC2626' },
      --   warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
      --   info = { 'DiagnosticInfo', '#2563EB' },
      --   hint = { 'Character', '#10B981' },
      --   default = { 'Identifier', '#7C3AED' },
      --   test = { 'Identifier', '#FF00FF' },
      -- },
    },
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    -- enabled = false,
    build = ':TSUpdate',
    -- opts = {
    -- },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        ensure_installed = 'all',
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = {
          enable = true,
          disable = {
            'latex',
            -- 'markdown',
          },
          -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
          --  If you are experiencing weird indenting issues, add the language to
          --  the list of additional_vim_regex_highlighting and disabled languages for indent.
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true, disable = { 'ruby' } },

        textobjects = {
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
          },

          select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              -- You can optionally set descriptions to the mappings (used in the desc parameter of
              -- nvim_buf_set_keymap) which plugins like which-key display
              ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
              -- You can also use captures from other query groups like `locals.scm`
              ['as'] = { query = '@scope', query_group = 'locals', desc = 'Select language scope' },
            },
            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V', -- linewise
              ['@class.outer'] = '<c-v>', -- blockwise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true or false
            include_surrounding_whitespace = true,
          },
        },
      }
    end,
  },
  -- { 'nvim-treesitter/playground' },
  {

    'nvim-treesitter/nvim-treesitter-textobjects',
    -- enabled=false,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  -- {
  --   'nvim-treesitter/nvim-treesitter-context',
  --   dependencies = { 'nvim-treesitter/nvim-treesitter' },
  --   event = 'VimEnter',
  --   enabled = false,
  --   config = function()
  --     ---@diagnostic disable-next-line: missing-fields
  --     require('treesitter-context').setup {
  --       enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  --       -- separator = '',
  --       trim_scope = 'inner', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  --       max_lines = 1,
  --       -- line_numbers = false
  --     }
  --   end,
  -- },

  require 'plugins.indent_line',
  require 'plugins.neo-tree',
  require 'plugins.autopairs',
  require 'plugins.lint',

  { import = 'plugins' },
  ---@diagnostic disable-next-line: missing-fields
}, {
  ui = {
    icons = {
      loaded = '',
      not_loaded = '',
    },
  },
  change_detection = {
    notify = false,
  },
})
