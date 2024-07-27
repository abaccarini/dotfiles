return {
  'stevearc/overseer.nvim',
  opts = {},

  init = function()
    require('overseer').setup {

      task_list = {
        bindings = {
          ['<C-l>'] = '<C-w><C-l>',
          ['<C-k>'] = '<C-w><C-k>',
          ['<C-j>'] = '<C-w><C-j>',
          ['<C-h>'] = '<C-w><C-h>',
        },
      },
    }
  end,
}
