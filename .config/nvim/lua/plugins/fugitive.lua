return {
  'tpope/vim-fugitive',
  config = function()
    vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = 'Status' })
    vim.keymap.set('n', '<leader>gp', function()
      vim.cmd.Git 'pull'
    end, { desc = 'Pull' })
    -- vim.keymap.set('n', '<leader>gp', function()
    --   vim.cmd.Git 'pull'
    -- end, { desc = '[G]it [P]ull' })
  end,
}
