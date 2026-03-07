return { -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = 'VeryLazy',
  -- enabled = false,
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      'L3MON4D3/LuaSnip',
      opts = {
        -- history = true,
        enable_autosnippets = true,
        store_selction_keys = '<Tab>',
        update_events = 'TextChanged,TextChangedI',
      },
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        {
          'rafamadriz/friendly-snippets',
          config = function()
            -- require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
      config = function()
        require('luasnip').config.setup {
          history = true,
          -- Enable autotriggered snippets
          enable_autosnippets = true,
          store_selection_keys = '<Tab>',
        }
      end,
    },
    'saadparwaiz1/cmp_luasnip',

    -- Adds other completion capabilities.
    --  nvim-cmp does not ship with all sources by default. They are split
    --  into multiple repos for maintenance purposes.
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'lukas-reineke/cmp-rg',
    -- 'onsails/lspkind.nvim',
    -- 'hrsh7th/cmp-omni',
    'hrsh7th/cmp-emoji',
    {
      'f3fora/cmp-spell',
      config = function()
        -- vim.opt.spell = true
        -- vim.opt.spelllang:append "en_us"
      end,
    },
    {
      'micangl/cmp-vimtex',

      config = function()
        -- vim.keymap.set('n', '<leader>S', 'z=')
        -- require('cmp_vimtex').setup {
        --   additional_information = {
        --     info_in_menu = true,
        --     info_in_window = true,
        --     info_max_length = 60,
        --     match_against_info = true,
        --     symbols_in_menu = true,
        --   },
        --   bibtex_parser = {
        --     enabled = true,
        --   },
        -- }
        -- require('cmp_vimtex').setup {}
        -- require('luasnip.loaders.from_vscode').lazy_load()
      end,
    },
  },
  config = function()
    require('luasnip.loaders.from_lua').lazy_load { paths = '~/.config/nvim/lua/plugins/snippets/' }
    -- require('luasnip.loaders.from_snipmate').lazy_load { paths = '~/.config/nvim/lua/plugins/snipmate/' }
    require('luasnip.loaders.from_vscode').lazy_load {
      exclude = { 'tex' },
    }

    local kind_icons = {
      Text = ' ',
      Method = '󰆧 ',
      Function = '󰊕 ',
      Constructor = ' ',
      Field = '󰇽 ',
      Variable = '󰀫 ',
      Class = '󰠱 ',
      Interface = ' ',
      Module = ' ',
      Property = '󰜢 ',
      Unit = ' ',
      Value = '󰎠 ',
      Enum = ' ',
      Keyword = '󰌋 ',
      Snippet = ' ',
      Color = '󰏘 ',
      File = '󰈙 ',
      Reference = ' ',
      Folder = '󰉋 ',
      EnumMember = ' ',
      Constant = '󰏿 ',
      Struct = ' ',
      Event = ' ',
      Operator = '󰆕 ',
      TypeParameter = '󰅲 ',
      Version = ' ',
    }

    -- See `:help cmp`
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    -- vim.cmd.hi 'BorderBG guibg=#FFB86C guifg=#FF79C6'

    local colors = require 'colors'

    vim.api.nvim_set_hl(0, 'CmpNormal', { fg = 'none', bg = colors['comment'] })
    vim.api.nvim_set_hl(0, 'CmpItemAbbr', { fg = colors['fg'], bg = 'none' })
    vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { bg = colors['menu'] })
    vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { fg = colors['cyan'], bg = 'none' })
    vim.api.nvim_set_hl(0, 'CmpItemMenu', { fg = colors['fg'], bg = colors['menu'] })

    -- vim.api.nvim_set_hl(0, 'PmenuSel', { bold = false, fg = 'none', bg = colors['selection'] })
    vim.api.nvim_set_hl(0, 'PmenuSel', { fg = 'none', bg = colors['selection'] })
    vim.api.nvim_set_hl(0, 'Pmenu', { fg = 'none', bg = colors['menu'] })

    -- local ELLIPSIS_CHAR = '…'
    -- local MAX_LABEL_WIDTH = 30
    -- local MIN_LABEL_WIDTH = 30

    vim.opt.pumheight = 12
    cmp.setup {

      -- disables completion in comments
      enabled = function()
        local disabled = false
        disabled = disabled or (vim.api.nvim_get_option_value('buftype', { buf = 0 }) == 'prompt')
        disabled = disabled or (vim.fn.reg_recording() ~= '')
        disabled = disabled or (vim.fn.reg_executing() ~= '')
        disabled = disabled or require('cmp.config.context').in_treesitter_capture 'comment'
        return not disabled
      end,
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' },
      window = {
        completion = {
          -- border = 'rounded',
          -- scrollbar = '',
          -- winhighlight = "Normal:BorderBG,Search:BorderBG",
          -- winhighlight = 'Normal:BorderBG,FloatBorder:BorderBG,CursorLine:None,Search:BorderBG',
          -- winhighlight = 'CursorLine:CursorLine',
        },
        documentation = {
          winhighlight = 'Normal:Pmenu',
        },
      },

      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        -- fields = { 'kind', 'abbr', 'menu' },
        -- fields = { cmp.ItemField.Kind, cmp.ItemField.Abbr, cmp.ItemField.Menu },
        -- fields = {},
        expandable_indicator = true,
        format = function(entry, vim_item)
          -- Kind icons
          vim_item.kind = string.format('%s', kind_icons[vim_item.kind], vim_item.kind)
          -- vim_item.kind = string.format('%s',  vim_item.kind) -- to debug
          -- Source
          -- vim_item.menu = ({
          --   buffer = '[Buffer]',
          --   nvim_lsp = '[LSP]',
          --   luasnip = '[LuaSnip]',
          --   nvim_lua = '[Lua]',
          --   latex_symbols = '[LaTeX]',
          -- })[entry.source.name]
          return vim_item
        end,
        -- format = lspkind.cmp_format {
        --   mode = 'symbol', -- show only symbol annotations
        --   -- maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        --   -- can also be a function to dynamically calculate max width such as
        --   -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
        --   -- ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        --   show_labelDetails = true, -- show labelDetails in menu. Disabled by default

        --   -- The function below will be called before any actual modifications from lspkind
        --   -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
        --   --
        --   before = function(entry, vim_item)
        --     local label = vim_item.abbr
        --     local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
        --     if truncated_label ~= label then
        --       vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
        --     elseif string.len(label) < MIN_LABEL_WIDTH then
        --       local padding = string.rep(' ', MIN_LABEL_WIDTH - string.len(label))
        --       vim_item.abbr = label .. padding
        --     end
        --     return vim_item
        --   end,
        -- },
      },

      mapping = cmp.mapping.preset.insert {
        -- Select the [n]ext item
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- Select the [p]revious item
        ['<CS-N>'] = cmp.mapping.select_prev_item(),

        -- Scroll the documentation window [b]ack / [f]orward
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),

        -- Accept the completion.
        --  This will auto-import if your LSP supports it.
        --  This will expand snippets if the LSP sent a snippet.
        ['<Tab>'] = cmp.mapping.confirm { select = true },
        -- ['<Return>'] = cmp.mapping.confirm { select = true },

        -- Manually trigger a completion from nvim-cmp.
        --  Generally you don't need this, because nvim-cmp will display
        --  completions whenever it has completion options available.
        ['<C-Space>'] = cmp.mapping.complete {},

        -- Think of <c-l> as moving to the right of your snippet expansion.
        --  So if you have a snippet that's like:
        --  function $name($args)
        --    $body
        --  end
        --

        -- <c-l> will move you to the right of each of the expansion locations.
        -- <c-h> is similar, except moving you backwards.
        ['<C-k>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          end
        end, { 'i', 's' }),
        ['<C-j>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },
      sources = {
        { name = 'nvim_lsp', max_item_count = 12 },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'rg' },
        -- { name = 'emoji', option = { insert = true } },

        {
          name = 'spell',
          option = {
            keep_all_entries = false,
            enable_in_context = function()
              return true
            end,
            preselect_correct_word = true,
          },
        },
        -- { name = 'omni' },
      },
      -- experimental = {
      --   ghost_text = true,
      -- },
    }
    cmp.setup.filetype({ 'tex', 'wiki' }, {
      sources = cmp.config.sources {
        { name = 'luasnip' },
        -- { name = 'omni' },
        { name = 'vimtex' },
        { name = 'buffer' },
        { name = 'path', option = { trailing_slash = true } },
        { name = 'calc' },
      },
    })

    cmp.setup.filetype({ 'markdown' }, {
      sources = cmp.config.sources {
        { name = 'luasnip' },
        -- { name = 'omni' },
        { name = 'buffer' },
        { name = 'path', option = { trailing_slash = true } },
        { name = 'calc' },
        { name = 'emoji', option = { insert = true } },
      },
    })
    -- cmp.setup.cmdline('/', {
    --   mapping = cmp.mapping.preset.cmdline(),
    --   sources = {
    --     { name = 'buffer' }
    --   }
    -- })

    -- cmp.setup.cmdline(':', {
    --   mapping = cmp.mapping.preset.cmdline {

    --     ['<C-n>'] = {
    --       c = function(fallback)
    --         -- local cmp = require 'cmp'
    --         if cmp.visible() then
    --           cmp.select_next_item()
    --         else
    --           fallback()
    --         end
    --       end,
    --     },
    --     -- Select the [p]revious item
    --     -- ['<CS-N>'] = cmp.mapping.select_prev_item(),

    --     ['<CS-N>'] = {
    --       c = function(fallback)
    --         -- local cmp = require 'cmp'
    --         if cmp.visible() then
    --           cmp.select_prev_item()
    --         else
    --           fallback()
    --         end
    --       end,
    --     },
    --   },
    --   sources = cmp.config.sources({
    --     { name = 'path' },
    --   }, {
    --     {
    --       name = 'cmdline',
    --       option = {
    --         ignore_cmds = { 'Man', '!' },
    --       },
    --     },
    --   }),
    -- })

    -- for _, ft_path in ipairs(vim.api.nvim_get_runtime_file('lua/snippets/*.lua', true)) do
    --   loadfile(ft_path)()
    -- end
  end,
}
