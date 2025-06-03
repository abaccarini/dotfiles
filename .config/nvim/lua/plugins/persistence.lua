return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {
    dir = vim.fn.expand '$HOME/nvim_sessions/',
    need = 1,
    -- options = vim.opt.sessionoptions:get(),
  },
}
