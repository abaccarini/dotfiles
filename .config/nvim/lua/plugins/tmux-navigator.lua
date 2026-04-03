return {
  'christoomey/vim-tmux-navigator',
  -- enabled = false,
  -- lazy = false,
  -- cmd = {
  --   'TmuxNavigateLeft',
  --   'TmuxNavigateDown',
  --   'TmuxNavigateUp',
  --   'TmuxNavigateRight',
  --   'TmuxNavigatePrevious',
  --   'TmuxNavigatorProcessList',
  -- },
  -- keys = {
  --   { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
  --   { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
  --   { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
  --   { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
  --   { '<c-\\>', ':Neotree toggle<CR>' },
  -- },
  init = function()
    vim.g.tmux_navigator_no_mappings = 1
    vim.g.tmux_navigator_disable_when_zoomed = 1
    vim.g.tmux_navigator_no_wrap = 1

    vim.keymap.set('n', '<C-h>', '<cmd>TmuxNavigateLeft<cr>', { desc = 'Focus left' })
    vim.keymap.set('n', '<C-j>', '<cmd>TmuxNavigateDown<cr>', { desc = 'Focus down' })
    vim.keymap.set('n', '<C-k>', '<cmd>TmuxNavigateUp<cr>', { desc = 'Focus up' })
    vim.keymap.set('n', '<C-l>', '<cmd>TmuxNavigateRight<cr>', { desc = 'Focus right' })
    -- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right' })
    -- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus below' })
    -- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus above' })
  end,
}
