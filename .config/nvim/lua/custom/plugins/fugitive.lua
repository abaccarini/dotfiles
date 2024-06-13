return {
  'tpope/vim-fugitive',
  config = function()
    vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = '[G]it [S]tatus' })
    vim.keymap.set('n', '<leader>gp', function()
      vim.cmd.Git 'pull'
    end, { desc = '[G]it [P]ull' })
    -- vim.keymap.set('n', '<leader>gp', function()
    --   vim.cmd.Git 'pull'
    -- end, { desc = '[G]it [P]ull' })
  end,
}
