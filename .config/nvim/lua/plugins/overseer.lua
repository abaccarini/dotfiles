return {
  'stevearc/overseer.nvim',
  event = 'VeryLazy',
  lazy = true,
  opts = {
    task_list = {
      min_width = { 40, 0.3 },
      bindings = {
        ['<C-l>'] = false,
        ['<C-k>'] = false,
        ['<C-j>'] = false,
        ['<C-h>'] = false,
      },
    },
  },
  init = function()
    local colors = require 'colors'

    vim.api.nvim_set_hl(0, 'OverseerSUCCESS', { fg = colors['green'] })
    vim.api.nvim_set_hl(0, 'OverseerCANCELED', { fg = colors['orange'] })
    vim.api.nvim_set_hl(0, 'OverseerFAILURE', { bold = true, fg = colors['red'] })

    -- vim.keymap.set('n', '<leader>ot', '<Cmd>OverseerToggle<CR>', {})

    local wk = require 'which-key'
    wk.add {
      -- -- buffer = event.buf,
      {
        '<localleader>o',
        '<Cmd>OverseerToggle<CR>',
        desc = 'Overseer',
        icon = { icon = ' ', color = 'green' },
      },

      -- mode = 'n',
      -- {
      --   '<localleader>ot',
      --   '<Cmd>OverseerToggle<CR>',
      --   desc = 'Toggle',
      --   icon = { icon = ' ', color = 'green' },
      -- },
      {
        '<localleader>to',
        '<Cmd>OverseerToggle<CR>',
        desc = 'Overseer',
        icon = { icon = ' ', color = 'green' },
      },
    }
  end,
}
