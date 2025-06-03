return {
  'folke/persistence.nvim',
  event = 'BufReadPre',

  opts = {
    dir = vim.fn.expand '$HOME/nvim_sessions/',
    options = vim.opt.sessionoptions:get(),
  },
  -- config = function()
  -- end,
}
