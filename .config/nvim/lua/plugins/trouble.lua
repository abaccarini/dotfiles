return {
  'folke/trouble.nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  lazy = false,
  -- enabled = false,
  event = 'VimEnter',
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = 'Trouble',
  keys = {
    {
      '<leader>xx',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Diagnostics',
    },
    {
      '<leader>xX',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = 'Buffer Diagnostics',
    },
    {
      '<leader>xs',
      '<cmd>Trouble symbols toggle focus=false<cr>',
      desc = 'Document symbols',
    },
    {
      '<leader>xl',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = 'LSP defs/refs/...',
    },
    {
      '<leader>xL',
      '<cmd>Trouble loclist toggle<cr>',
      desc = 'Location List',
    },
    {
      '<leader>xQ',
      '<cmd>Trouble qflist toggle<cr>',
      desc = 'Quickfix List',
    },
  },
}
