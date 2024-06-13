return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = { 'nvim-tree/nvim-web-devicons', 'Mofiqul/dracula.nvim' },

  event = 'VimEnter',
  keys = {
    { '<leader>jb', '<Cmd>BufferLinePick<CR>', desc = 'Jump to buffer' },
    { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle Pin' },
    { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
    { '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Delete Other Buffers' },
    { '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete Buffers to the Right' },
    { '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete Buffers to the Left' },
    -- { '<leader>bd', '<Cmd>bd<CR>', desc = 'Delete Buffers to the Left' },
    { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
    { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
  },

  config = function()
    vim.keymap.set('n', '<leader>bd', '<Cmd>bd<cr>', { desc = 'Delete Buffer' })
    vim.opt.termguicolors = true
    -- vim.cmd.hi('BufferLineFill guifg=none guibg=none')
    local dracula = require 'dracula'
    local colors = dracula.colors()
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
          -- italic = false,
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
          italic = true,
        },
        pick = {
          bg = colors['menu'],
          fg = colors['red'],
          -- fg = colors['red'],
          bold = true,
          italic = true,
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
          fg = colors['menu'],
          bg = colors['menu'],
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
        custom_filter = function(buf_number, buf_numbers)
          local buf_name = vim.fn.bufname(buf_number)
          -- so we can edit the fugitive config file, while preventing the actual fugitive window from being shown
          if string.find(buf_name, 'fugitive') and not string.find(buf_name, 'fugitive.lua') then
            return false
          end

          local filetype = vim.bo[buf_number].filetype

          if filetype == 'gitcommit' then
            return false
          end

          if filetype == '' and buf_name == '' then
            return false
          end

          if filetype == 'qf' then
            return false
          end
          return true
        end,

        -- custom_filter = function(buf_number, _)
        --   if vim.bo[buf_number].filetype ~= 'qf' or vim.bo[buf_number].buftype ~= 'fugitive' then
        --     return true
        --   else
        --     return false
        --   end
        -- end,
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
        always_show_bufferline = false,
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match 'error' and ' ' or ' '
          return ' ' .. icon .. count
        end,
      },
    }
    -- numbers = function(opts)
    --   return string.format('%s.', opts.ordinal)
    -- end,

    -- indicator = {
    --   icon = '▎',
    --   style = 'icon',
    -- },
    --
    -- buffer_close_icon = '',
    -- modified_icon = '●',
    -- close_icon = '',
    -- left_trunc_marker = '',
    -- right_trunc_marker = '',
    -- max_name_length = 18,
    -- max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
    -- tab_size = 18,
    -- diagnostics = 'nvim_lsp',
    -- diagnostics_update_in_insert = false,
    --
    -- diagnostics_indicator = function(count, level, diagnostics_dict, context)
    --   return '(' .. count .. ')'
    -- end,
    --
    -- offsets = { { filetype = 'NvimTree', text_align = 'left' } },
    -- show_buffer_icons = true,
    -- show_buffer_close_icons = false,
    -- show_close_icon = false,
    -- show_tab_indicators = true,
    -- persist_buffer_sort = true,
    -- enforce_regular_tabs = false,
    -- sort_by = 'id',
    -- require('bufferline').setup(opts) {
    -- Fix bufferline when restoring a session
    -- }
  end,
}
