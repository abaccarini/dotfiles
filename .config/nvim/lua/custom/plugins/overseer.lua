return {
  'stevearc/overseer.nvim',
  opts = {},

  dependencies = {
    'Mofiqul/dracula.nvim',
  },
  init = function()
    local dracula = require 'dracula'
    local colors = dracula.colors()

    vim.api.nvim_set_hl(0, 'OverseerSUCCESS', {  fg = colors['green'] })
    vim.api.nvim_set_hl(0, 'OverseerCANCELED', {  fg = colors['orange'] })
    vim.api.nvim_set_hl(0, 'OverseerFAILURE', {  bold = true, fg = colors['red'] })


    vim.keymap.set('n', '<leader>o', '<Cmd>OverseerToggle<CR>')
    require('overseer').setup {

      task_list = {
            min_width = { 40, 0.3},
        bindings = {
          ['<C-l>'] = false,
          ['<C-k>'] = false,
          ['<C-j>'] = false,
          ['<C-h>'] = false,
        },
      },
    }
  end,
}
