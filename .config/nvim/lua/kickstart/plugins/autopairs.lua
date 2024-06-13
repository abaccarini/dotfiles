-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  'windwp/nvim-autopairs',
  -- enabled = false,
  lazy = true,
  event = 'InsertEnter',
  -- Optional dependency
  dependencies = { 'hrsh7th/nvim-cmp' },
  config = function()
    local Rule = require 'nvim-autopairs.rule'
    local npairs = require 'nvim-autopairs'
    local cond = require 'nvim-autopairs.conds'
    require('nvim-autopairs').setup {

      -- disable_filetype = { 'tex' },
    }
    npairs.add_rule(Rule('$', '$', 'tex'))
    -- If you want to automatically add `(` after selecting a function or method
    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    local cmp = require 'cmp'
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    npairs.add_rule(Rule('"', '', 'tex'))
    npairs.add_rule(Rule('"', ''):with_pair(cond.not_filetypes { 'tex' }))
    -- npairs.remove_rule("\"")
  end,
}
