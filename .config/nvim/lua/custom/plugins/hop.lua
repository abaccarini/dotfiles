return {
  'smoka7/hop.nvim',

  -- enabled = false,
  dependencies = { 'Mofiqul/dracula.nvim' },
  version = '*',
  opts = {
    keys = 'etovxqpdygfblzhckisuran',
  },
  config = function()
    require('hop').setup {}
    local hop = require 'hop'
    local directions = require('hop.hint').HintDirection
    vim.keymap.set('n', '<leader>jw', function()
      hop.hint_patterns { direction = directions.AFTER_CURSOR, current_line_only = false }
    end, { remap = true })
    vim.keymap.set('n', '<leader>jW', function()
      hop.hint_patterns { direction = directions.BEFORE_CURSOR, current_line_only = false }
    end, { remap = true })
    -- vim.keymap.set('', 't', function()
    --   hop.hint_char1 { direction = directions.AFTER_CURSOR, current_line_only = false, hint_offset = -1 }
    -- end, { remap = true })
    -- vim.keymap.set('', 'T', function()
    --   hop.hint_char1 { direction = directions.BEFORE_CURSOR, current_line_only = false, hint_offset = 1 }
    -- end, { remap = true })

    vim.keymap.set('', '<leader>jl', function()
      hop.hint_lines_skip_whitespace { current_line_only = false, hint_offset = 1 }
    end, { remap = true })

    local colors = require('dracula').colors()
    vim.api.nvim_set_hl(0, 'HopUnmatched', { link = 'Comment' })
    -- vim.api.nvim_set_hl(0, "HopNextKey", {link = "Comment"})
    -- vim.api.nvim_set_hl(0, "HopNextKey1", {link = "Comment"})
    -- vim.api.nvim_set_hl(0, "HopNextKey2", {link = "Comment"})

    vim.api.nvim_set_hl(0, 'HopPreview', {
      fg = colors['green'],
      bold = true,
      -- nocombine = true,
    })
    vim.api.nvim_set_hl(0, 'HopNextKey', {
      fg = colors['red'],
      bold = true,
      -- nocombine = true,
    })
    --
    vim.api.nvim_set_hl(0, 'HopNextKey1', {
      fg = colors['red'],
      bold = true,
      -- nocombine = true,
    })

    vim.api.nvim_set_hl(0, 'HopNextKey2', {
      fg = colors['bright_red'],
      bold = true,
      -- nocombine = true,
    })
  end,
}
