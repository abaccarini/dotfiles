return {
  enabled=false,
  'folke/snacks.nvim',
  ---@type snacks.Config
  dependencies = { 'Mofiqul/dracula.nvim' },
  opts = {
    indent = {
      hl = 'guibg=#FFB86C guifg=#FF79C6', ---@type string|string[] hl groups for indent guides
      -- your indent configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      animate = {
        enabled = false,
      },
    },
  },
  -- config = function()
  -- require('snacks').setup {
  -- vim.cmd.hi 'SnacksIndent1 guibg=#FFB86C guifg=#FF79C6'
  -- }
  -- vim.api.nvim_set_hl(0, 'SnacksIndent1', 'Comment')
  -- vim.cmd.hi 'SSnacksIndent1  nacksIndent1  Comment'
  -- end,
}
