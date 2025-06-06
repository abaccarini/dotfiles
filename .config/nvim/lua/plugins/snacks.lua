local colors = require 'colors'
local hl = vim.api.nvim_set_hl

-- hl(0, 'SnacksIndent', { fg = colors.comment, bg=colors.red })
hl(0, 'SnacksIndentScope', { fg = colors.comment })
return {
  enabled = false,
  'folke/snacks.nvim',
  -- dependencies = { 'Mofiqul/dracula.nvim' },
  opts = {
    indent = {
      -- hl = 'guibg='..colors.red.. 'guifg='..colors.green, ---@type string|string[] hl groups for indent guides
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
