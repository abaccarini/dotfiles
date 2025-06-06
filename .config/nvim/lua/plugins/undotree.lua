return {
  'mbbill/undotree',
  event = 'VimEnter',
  init = function()
    vim.keymap.set('n', '<leader>tu', vim.cmd.UndotreeToggle, { desc = 'Undotree' })
  end,
}
