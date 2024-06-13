return { -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
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
          'lervag/vimtex',
          'rafamadriz/friendly-snippets',
          config = function()
            -- require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
      -- config = function()
      --   require('luasnip').config.setup {
      --     history = true,
      --     -- Enable autotriggered snippets
      --     enable_autosnippets = true,
      --     store_selection_keys = '<Tab>',
      --   }
      -- end,
    },
    'saadparwaiz1/cmp_luasnip',

    -- Adds other completion capabilities.
    --  nvim-cmp does not ship with all sources by default. They are split
    --  into multiple repos for maintenance purposes.
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'onsails/lspkind.nvim',
    'hrsh7th/cmp-omni',
    'f3fora/cmp-spell',
    {
      'micangl/cmp-vimtex',

      config = function()
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
    require('luasnip.loaders.from_lua').lazy_load { paths = '~/.config/nvim/lua/custom/plugins/snippets/' }
    require('luasnip.loaders.from_snipmate').lazy_load { paths = '~/.config/nvim/lua/custom/plugins/snipmate/' }
    require('luasnip.loaders.from_vscode').lazy_load()
    -- See `:help cmp`
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    local lspkind = require 'lspkind'
    lspkind.init {
      symbol_map = {
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
      },
    }

    vim.cmd.hi 'BorderBG guibg=#FFB86C guifg=#FF79C6'

    local dracula = require 'dracula'
    local colors = dracula.colors()

    -- vim.api.nvim_set_hl(0, 'ClineBG', { fg = 'none', bg = colors['comment'] })

    -- vim.cmd 'highlight! BorderBG guibg=NONE guifg=#00ff00'
    vim.api.nvim_set_hl(0, 'CmpNormal', { fg = 'none', bg = colors['comment'] })
    vim.api.nvim_set_hl(0, 'PmenuSel', { bold = true, fg = 'none', bg = colors['selection'] })

    -- vim.api.nvim_set_hl(0, 'ClineBG', { fg = 'none', bg = colors['comment'] })

    -- vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#282C34', fg = 'none' })

    -- vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { fg = 'None', bg = colors['menu'] })
    -- for
    vim.api.nvim_set_hl(0, 'CmpItemAbbr', { fg = colors['fg'], bg = colors['menu'] })
    vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { bg = colors['menu'] })
    vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { fg = colors['cyan'], bg = colors['menu'] })
    -- vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { fg = 'None', bg = '#21222C' })
    -- vim.api.nvim_set_hl(0, 'CmpItemMenu', { fg = 'None', bg = '#21222C', italic = true })
    vim.api.nvim_set_hl(0, 'CmpItemMenu', { fg = colors['fg'], bg = colors['menu'] })
    vim.api.nvim_set_hl(0, 'CmpItemMenu', { fg = colors['fg'], bg = colors['menu'] })

    local ELLIPSIS_CHAR = '…'
    local MAX_LABEL_WIDTH = 30
    local MIN_LABEL_WIDTH = 30

    cmp.setup {
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
        -- fields = { cmp.ItemField.Kind, cmp.ItemField.Abbr, cmp.ItemField.Menu },
        -- fields = {},
        expandable_indicator = true,
        format = lspkind.cmp_format {
          mode = 'symbol', -- show only symbol annotations
          -- maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          -- can also be a function to dynamically calculate max width such as
          -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
          -- ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          show_labelDetails = true, -- show labelDetails in menu. Disabled by default

          -- The function below will be called before any actual modifications from lspkind
          -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
          --
          before = function(entry, vim_item)
            local label = vim_item.abbr
            local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
            if truncated_label ~= label then
              vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
            elseif string.len(label) < MIN_LABEL_WIDTH then
              local padding = string.rep(' ', MIN_LABEL_WIDTH - string.len(label))
              vim_item.abbr = label .. padding
            end
            return vim_item
          end,
        },
      },

      -- For an understanding of why these mappings were
      -- chosen, you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
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
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
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
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
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
        -- { name = "omni" },
        { name = 'vimtex' },
        { name = 'buffer' },
        { name = 'path', option = { trailing_slash = true } },
        { name = 'calc' },
      },
    })

    for _, ft_path in ipairs(vim.api.nvim_get_runtime_file('lua/custom/snippets/*.lua', true)) do
      loadfile(ft_path)()
    end
  end,
}
