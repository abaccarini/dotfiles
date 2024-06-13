return {
  'mbbill/undotree',
  event = 'VimEnter',
  init = function()
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Toggle [U]ndoTree' })
  end,
}
