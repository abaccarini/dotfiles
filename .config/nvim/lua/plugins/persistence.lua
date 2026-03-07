return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {
    dir = vim.fn.expand '$HOME/nvim_sessions/',
    need = 1,
  },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'PersistenceSavePre',
      callback = function()
        vim.cmd ':Neotree close'
      end,
    })
  end,
}
