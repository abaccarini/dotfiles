-- To tirgger path command, blink uses the directory of the current buffer.
-- e.g., if we type "./" within *this file*, it will show snipmate/,snippets/,*.lua, ...

local function lspkind_config()
  local lspKindConfig = require 'lspkind'
  lspKindConfig.init {
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
end
-- local source_priority = {
--   snippets = 4,
--   -- vimtex = 4,
--   lsp = 3,
--   path = 2,
--   buffer = 1,
-- }

local colors = require 'colors'
local hl = vim.api.nvim_set_hl

hl(0, 'BlinkCmpDoc', { bg = colors.menu })
hl(0, 'BlinkCmpDocSeparator', { bg = colors.menu })
hl(0, 'BlinkCmpMenuSelection', { fg = 'none', bg = colors.selection, bold = true })
hl(0, 'BlinkCmpMenu', { bg = colors.menu })
hl(0, 'BlinkCmpScrollBarThumb', { bg = colors.gutter_fg })
hl(0, 'BlinkCmpScrollBarGutter', { bg = colors.menu })
hl(0, 'LabelMatch', { fg = colors.bright_cyan, bold = true })
hl(0, 'LabelRest', { bg = colors.menu })
hl(0, 'KindBG', { bg = colors.menu })

hl(0, 'BlinkCmpKind', { bg = colors.red, fg = colors.red })
hl(0, 'BlinkCmpKindText', { bg = colors.menu })

local function inside_comment_block()
  if vim.api.nvim_get_mode().mode ~= 'i' then
    return false
  end
  local node_under_cursor = vim.treesitter.get_node()
  local parser = vim.treesitter.get_parser(nil, nil, { error = false })
  if not parser or not node_under_cursor then
    return false
  end
  local query = vim.treesitter.query.get(parser:lang(), 'highlights')
  if not query then
    return false
  end
  ---@diagnostic disable-next-line: deprecated
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  for id, node, _ in query:iter_captures(node_under_cursor, 0, row, row + 1) do
    if query.captures[id]:find 'comment' then
      local start_row, start_col, end_row, end_col = node:range()
      if start_row <= row and row <= end_row then
        if start_row == row and end_row == row then
          if start_col <= col and col <= end_col then
            return true
          end
        elseif start_row == row then
          if start_col <= col then
            return true
          end
        elseif end_row == row then
          if col <= end_col then
            return true
          end
        else
          return true
        end
      end
    end
  end
  return false
end

return {
  {
    'saghen/blink.compat',
    -- use v2.* for blink.cmp v1.*
    version = '2.*',
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    'saghen/blink.cmp',

    event = 'VeryLazy',
    -- optional: provides snippets for the snippet source
    -- dependencies = {  },
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            -- config = function()
            --   -- require('luasnip.loaders.from_vscode').lazy_load()
            -- end,
          },
        },
        -- opts = {
        --   history = true,
        --   -- Enable autotriggered snippets
        --   enable_autosnippets = true,
        --   store_selection_keys = '<Tab>',
        -- },
        config = function()
          -- enabling tex snippets from inside markdown, likely need to customize 
          -- require('luasnip').filetype_extend('markdown', { 'tex' })
          require('luasnip.loaders.from_lua').lazy_load { paths = '~/.config/nvim/lua/plugins/snippets/' }
          require('luasnip.loaders.from_snipmate').lazy_load { paths = '~/.config/nvim/lua/plugins/snipmate/' }
          require('luasnip.loaders.from_vscode').lazy_load {
            exclude = { 'tex' },
          }
          -- require('luasnip').filetype_extend('tex', { 'markdown' })
          require('luasnip').config.setup {
            history = true,
            -- Enable autotriggered snippets
            enable_autosnippets = true,
            store_selection_keys = '<Tab>',
            update_events = 'TextChanged,TextChangedI',
          }
        end,
      },
      { 'micangl/cmp-vimtex' },

      { 'moyiz/blink-emoji.nvim' },
      { 'onsails/lspkind.nvim', config = lspkind_config },
    },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = { preset = 'luasnip' },
      -- ensure you have the `snippets` source (enabled by default)
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = 'default',
        ['<CS-N>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
        ['<C-k>'] = { 'snippet_forward', 'fallback' },
        ['<C-j>'] = { 'snippet_backward', 'fallback' },
        -- ['<CR>'] = { 'accept', 'fallback' }, -- was undesireably inserting snippets while typing markdown -> other langs too?
        ['<Tab>'] = { 'accept', 'fallback' },
        ['<C-space>'] = {
          function(cmp)
            cmp.show {}
          end,
        },
        -- ['<Return>'] = { 'select_and_accept' },
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'normal',
      },
      cmdline = {
        keymap = {
          ['<CR>'] = { 'accept_and_enter', 'fallback' },
          -- ['<Tab>'] = { 'select_and_accept', 'select_next' },
          -- ['<S-Tab>'] = { 'show_and_insert', 'select_prev' },
          ['<CS-N>'] = { 'select_prev', 'fallback_to_mappings' },
          ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
        },
        completion = {
          menu = {
            auto_show = function(ctx)
              return vim.fn.getcmdtype() == ':'
              -- enable for inputs as well, with:
              -- or vim.fn.getcmdtype() == '@'
            end,
          },
        },
      },
      -- (Default) Only show the documentation popup when manually triggered
      completion = {
        -- ghost_text = { enabled = true },
        documentation = { auto_show = true, auto_show_delay_ms = 0 },
        menu = {
          -- winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None,ExtraWhiteSpace:Normal',
          auto_show = true,
          -- border = border_chars,
          draw = {
            columns = {
              { 'kind_icon', gap = 1 },
              { 'label', 'source_name', gap = 1 },
            },
            components = {

              kind_icon = {
                text = function(ctx)
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                    local dev_icon, _ = require('nvim-web-devicons').get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  else
                    icon = require('lspkind').symbolic(ctx.kind, {
                      mode = 'symbol',
                    })
                  end

                  return icon .. ctx.icon_gap
                end,

                -- Optionally, use the highlight groups from nvim-web-devicons
                -- You can also add the same function for `kind.highlight` if you want to
                -- keep the highlight groups in sync with the icons.
                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                    local dev_icon, dev_hl = require('nvim-web-devicons').get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              },
              -- kind = {
              --   ellipsis = false,
              --   width = { fill = true },
              --   text = function(ctx)
              --     return ctx.kind
              --   end,
              --   highlight = function(ctx)
              --     return 'BlinkCmpKind' .. ctx.kind
              --   end,
              -- },
              label = {
                width = { fill = true, max = 60 },
                text = function(ctx)
                  return ctx.label .. ctx.label_detail
                end,
                highlight = function(ctx)
                  -- label and label details
                  local highlights = {
                    {
                      0,
                      #ctx.label,
                      group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'LabelRest',
                    },
                  }
                  if ctx.label_detail then
                    table.insert(highlights, { #ctx.label, #ctx.label + #ctx.label_detail, group = 'BlinkCmpLabelDetail' })
                  end

                  -- characters matched on the label by the fuzzy matcher
                  for _, idx in ipairs(ctx.label_matched_indices) do
                    table.insert(highlights, { idx, idx + 1, group = 'LabelMatch' })
                  end

                  return highlights
                end,
              },
              source_name = {
                width = { max = 30 },
                text = function(ctx)
                  return ctx.source_name
                end,
                highlight = 'BlinkCmpSource',
              },
            },
          },
        },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = function(ctx)
          -- local success, node = pcall(vim.treesitter.get_node)
          -- if success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
          --   return { 'buffer' }
          if inside_comment_block() then
            return {}
          elseif vim.bo.filetype == 'lua' then
            return { 'lsp', 'path', 'snippets' }
          else
            return { 'lsp', 'path', 'snippets', 'buffer', 'emoji' }
          end
        end,
        per_filetype = {
          tex = { inherit_defaults = true, 'vimtex' },
        },

        providers = {
          path = {
            score_offset = 8,
            opts = {
              get_cwd = function(_)
                return vim.fn.getcwd()
              end,
            },
          },
          snippets = { score_offset = 7 },
          buffer = { score_offset = -10 },
          lsp = { fallbacks = {} },
          cmdline = {
            min_keyword_length = function(ctx)
              -- when typing a command, only show when the keyword is 3 characters or longer
              if ctx.mode == 'cmdline' and string.find(ctx.line, ' ') == nil then
                return 3
              end
              return 0
            end,
          },
          vimtex = {
            name = 'vimtex',
            module = 'blink.compat.source',
            score_offset = 10,
            -- fallbacks = { 'buffer' },
          },
          emoji = {
            module = 'blink-emoji',
            name = 'emoji',
            score_offset = 10, -- Tune by preference
            opts = {
              insert = true, -- Insert emoji (default) or complete its name
              ---@type string|table|fun():table
              trigger = function()
                return { ':' }
              end,
            },
            should_show_items = function()
              return vim.tbl_contains(
                -- Enable emoji completion only for git commits and markdown.
                -- By default, enabled for all file-types.
                { 'gitcommit', 'markdown' },
                vim.o.filetype
              )
            end,
          },
        },
      },

      fuzzy = {
        implementation = 'rust',
      },
    },
    opts_extend = { 'sources.default' },
  },
}
