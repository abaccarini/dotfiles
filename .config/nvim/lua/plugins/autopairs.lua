-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  'windwp/nvim-autopairs',
  enabled = false,
  lazy = true,
  event = 'InsertEnter',
  config = function()
    local Rule = require 'nvim-autopairs.rule'
    local npairs = require 'nvim-autopairs'
    local cond = require 'nvim-autopairs.conds'
    require('nvim-autopairs').setup {
      -- map_cr = false,
      -- disable_filetype = { 'tex' },
    }

    npairs.add_rule(Rule('$', '$', 'tex'))

    npairs.add_rule(Rule('"', '', 'tex'))
    npairs.add_rule(Rule('"', ''):with_pair(cond.not_filetypes { 'tex' }))
  end,
}
