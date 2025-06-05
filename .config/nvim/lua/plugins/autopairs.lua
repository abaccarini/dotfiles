-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  'windwp/nvim-autopairs',
  -- enabled = false,
  lazy = true,
  event = 'InsertEnter',
  -- Optional dependency
  -- dependencies = { 'hrsh7th/nvim-cmp' },
  config = function()
    local Rule = require 'nvim-autopairs.rule'
    local npairs = require 'nvim-autopairs'
    local cond = require 'nvim-autopairs.conds'
    require('nvim-autopairs').setup {

      -- disable_filetype = { 'tex' },
    }
    npairs.add_rule(Rule('$', '$', 'tex'))
    -- If you want to automatically add `(` after selecting a function or method

    -- local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    -- local cmp = require 'cmp'
    -- cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

    npairs.add_rule(Rule('"', '', 'tex'))
    npairs.add_rule(Rule('"', ''):with_pair(cond.not_filetypes { 'tex' }))

    
    -- local opt = require('nvim-autopairs').config

    -- local basic = require 'nvim-autopairs.rules.basic'

    -- local utils = require 'nvim-autopairs.utils'
    -- local original_is_close_bracket = utils.is_close_bracket
    -- function utils.is_close_bracket(char)
    --   return original_is_close_bracket(char) or char == '>'
    -- end

    -- local bracket = basic.bracket_creator(opt)

    -- npairs.add_rules {
    --   bracket('<', '>'),
    -- }
    -- npairs.remove_rule("\"")
    local function jump_over_closing_pair()
      local line = vim.api.nvim_get_current_line()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local char_to_right = string.sub(line, col + 1, col + 1)
      local chars_to_jump = { '"', ')', ']', '}', "'", '>' }

      if vim.tbl_contains(chars_to_jump, char_to_right) then
        vim.cmd 'stopinsert'
        vim.api.nvim_feedkeys('la', 'n', true)
      else
        vim.cmd 'stopinsert'
      end
    end
    -- vim.keymap.set('i', '<esc>', jump_over_closing_pair, { noremap = true, silent = true })
    -- vim.keymap.set('i', '<C-h>', function()
    --   vim.cmd 'stopinsert'
    --   vim.api.nvim_feedkeys('ha', 'n', true)
    -- end)
    -- vim.keymap.set('i', '<C-l>', function()
    --   vim.cmd 'stopinsert'
    --   vim.api.nvim_feedkeys('la', 'n', true)
    -- end)
  end,
}
