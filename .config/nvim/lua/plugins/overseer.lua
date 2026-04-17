return {
  'stevearc/overseer.nvim',
  event = 'VeryLazy',
  enabled = false,
  lazy = true,
  -- opts = {
  --   task_list = {
  --     min_width = { 40, 0.3 },
  --     bindings = {
  --       ['<C-l>'] = false,
  --       ['<C-k>'] = false,
  --       ['<C-j>'] = false,
  --       ['<C-h>'] = false,
  --       -- ['<C-u>'] = 'ScrollOutputUp',
  --       -- ['<C-d>'] = '--[[ Sc ]]rollOutputDown',
  --     },
  --   },
  -- },
  init = function()
    local colors = require 'colors'

    vim.api.nvim_set_hl(0, 'OverseerSUCCESS', { fg = colors['green'] })
    vim.api.nvim_set_hl(0, 'OverseerCANCELED', { fg = colors['orange'] })
    vim.api.nvim_set_hl(0, 'OverseerFAILURE', { bold = true, fg = colors['red'] })
  end,
}
