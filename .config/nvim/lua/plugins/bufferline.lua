return {
  'akinsho/bufferline.nvim',
  -- event='VeryLazy',
  -- enabled = false,
  version = '*',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'Mofiqul/dracula.nvim',
    'echasnovski/mini.nvim',
  },
  event = 'BufEnter',
  keys = {
    { '<leader>jb', '<Cmd>BufferLinePick<CR>', desc = 'Buffer' },
    -- { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle Pin' },
    -- { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
    { '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Delete others' },
    { '<leader>bl', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete right' },
    { '<leader>bh', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete left' },
    { '<leader>bd', '<Cmd>BufferLinePickClose<CR>', desc = 'Delete __' },
    { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev buffer' },
    { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
    { '<C-M-h>', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer left' },
    { '<C-M-l>', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer right' },
  },

  config = function()
    -- vim.keymap.set('n', '<leader>w', function()
    --   vim.cmd 'silent only'
    --   vim.cmd.bd()
    -- end, { silent = true, desc = 'Delete Buffer' })

    vim.opt.termguicolors = true
    -- vim.cmd.hi('BufferLineFill guifg=none guibg=none')
    local colors = require 'colors'
    require('bufferline').setup {
      highlights = {
        -- modified_visible = {
        --   fg = colors['comment'],
        -- },
        -- modified_selected = {
        --   fg = colors['comment'],
        -- },
        -- modified = {
        --   fg = colors['comment'],
        -- },
        buffer_selected = {
          bold = true,
          -- sp = colors['red'],

          -- fg = colors['orange'],
          -- bg = '#FF5555',
        },
        -- tab_separator_selected = {
        --   underline = colors['red'],
        --   -- underline = '<colour-value-here>',
        -- },
        tab = {
          bg = colors['menu'],
        },
        background = {
          bg = colors['menu'],
        },
        -- indicator_selected = {
        --   sp = colors['red'],
        -- },
        -- indicator_selected = {
        --   sp = colors['red'],
        -- },
        tab_separator = {
          fg = colors['black'],
          bg = colors['menu'],
        },
        tab_separator_selected = {
          fg = colors['black'],
          -- bg = colors['menu'],
        },
        separator_visible = {
          fg = colors['black'],
          bg = colors['menu'],
        },
        separator_selected = {
          fg = colors['black'],
          -- bg = colors['menu'],
        },
        -- separator_visible = {
        --   -- fg = '<colour-value-here>',
        --   fg = colors['red'],
        --   bg = colors['red'],
        --   -- bold = true,
        --   -- italic = true,
        -- },
        pick_selected = {
          -- fg = '<colour-value-here>',
          -- fg = colors['red'],
          -- bg = colors['red'],
          -- bold = true,
          -- italic = true,
        },
        pick_visible = {
          bg = colors['menu'],
          fg = colors['red'],
          bold = true,
        },
        pick = {
          bg = colors['menu'],
          fg = colors['red'],
          -- fg = colors['red'],
          bold = true,
        },
        diagnostic = {
          bg = colors['menu'],
        },
        diagnostic_visible = {
          bg = colors['menu'],
        },
        hint = {
          bg = colors['menu'],
        },
        hint_visible = {
          bg = colors['menu'],
        },
        hint_diagnostic_visible = {
          bg = colors['menu'],
        },
        hint_diagnostic = {
          bg = colors['menu'],
        },
        warning_visible = {
          bg = colors['menu'],
        },
        warning = {
          bg = colors['menu'],
        },
        warning_diagnostic_visible = {
          bg = colors['menu'],
        },
        warning_diagnostic = {
          bg = colors['menu'],
        },
        error = {
          bg = colors['menu'],
        },
        error_visible = {
          bg = colors['menu'],
        },
        error_diagnostic = {
          bg = colors['menu'],
        },
        error_diagnostic_visible = {
          bg = colors['menu'],
        },
        info = {
          bg = colors['menu'],
        },
        indicator_visible = {
          bg = colors['menu'],
        },
        info_visible = {
          bg = colors['menu'],
        },
        info_diagnostic = {
          bg = colors['menu'],
        },
        info_diagnostic_visible = {
          bg = colors['menu'],
        },

        duplicate_selected = {
          -- fg = colors['menu'],
          -- bg = colors['menu'],
        },
        duplicate = {
          bg = colors['menu'],
        },
        duplicate_visible = {
          bg = colors['menu'],
        },
        modified = {
          bg = colors['menu'],
        },
        modified_visible = {
          bg = colors['menu'],
        },

        buffer_visible = {
          bg = colors['menu'],
        },
        -- tab_separator_selected = {
        --   fg = '#FF5555',
        --   bg = '#FF5555',
        -- },
        -- tab = {
        --   fg = '#FF5555',
        --   bg = '#FF5555',
        -- },
        -- background = {
        --   fg = '#FF5555',
        --   bg = '#FF5555',
        -- },
        -- background =
        --   fg = '#FF5555',
        --   bg = '#FF5555',
        -- },
        close_button = {
          -- fg = '#FF5555',
          bg = colors['menu'],
        },
      },
      options = {
        -- close_command = 'bdelete %d', -- can be a string | function, | false see "Mouse actions"
        close_command = 'lua MiniBufremove.delete(%d)', -- can be a string | function, | false see "Mouse actions"
        custom_filter = function(buf_number, buf_numbers)
          local buf_name = vim.fn.bufname(buf_number)
          -- so we can edit the fugitive config file, while preventing the actual fugitive window from being shown
          if string.find(buf_name, 'fugitive') and not string.find(buf_name, 'fugitive.lua') then
            return false
          end

          -- if string.find(vim.fs.basename(buf_name), '0') then
          if vim.fs.basename(buf_name) == '0' then
            return false
          end

          local filetype = vim.bo[buf_number].filetype

          if filetype == 'TelescopePrompt' then
            return false
          end

          if filetype == 'gitcommit' then
            return false
          end

          if filetype == 'dashboard' then
            return false
          end

          -- if filetype == '' and buf_name == '' then
          --   return false
          -- end

          if filetype == 'qf' then
            return false
          end

          local state = vim.uv.fs_stat(buf_name)
          if state and state.type == 'directory' then
            return false
          end

          return true
        end,

        offsets = {
          {
            filetype = 'neo-tree',
            text = 'File Tree',
            highlight = 'Directory',
            text_align = 'left',
          },
        },
        vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
          callback = function()
            vim.schedule(function()
              pcall(nvim_bufferline)
            end)
          end,
        }),
        style_preset = require('bufferline').style_preset.no_italic,
        separator_style = 'slant',
        indicator = {
          icon = '▎',
          -- style = 'icon',
          style = 'underline',
        },
        hover = {
          enabled = true,
          delay = 10,
          reveal = { 'close' },
        },
        -- show_buffer_icons = false,
        auto_toggle_bufferline = false,
        -- always_show_bufferline = false,
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match 'error' and ' ' or (level:match 'warning' and ' ' or ' ')
          -- local icon = level:match 'error' and ' '
          -- -- or (level:match 'warning' and ' ')
          return ' ' .. icon .. count
          -- local s = ' '
          -- for e, n in pairs(diagnostics_dict) do
          --   local sym = e == 'error' and ' ' or (e == 'warning' and ' ' or ' ')
          --   s = s .. sym
          -- end
          -- return s
        end,
      },
    }
  end,
}
