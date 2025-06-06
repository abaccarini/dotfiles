-- Adds git related signs to the gutter, as well as utilities for managing changes
-- NOTE: gitsigns is already included in init.lua but contains only the base
-- config. This will add also the recommended keymaps.

return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Next change' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Previous change' })

        -- Actions
        -- visual mode
        map('v', '<leader>ghs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Stage hunk' })
        map('v', '<leader>ghr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Reset hunk' })
        -- normal mode
        map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = 'Stage' })
        map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = 'Reset' })
        map('n', '<leader>ghu', gitsigns.stage_hunk, { desc = 'Undo stage' })
        map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = 'Preview' })

        map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'Stage buffer' })
        map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Reset buffer' })
        map('n', '<leader>gb', gitsigns.blame_line, { desc = 'Blame line' })
        map('n', '<leader>gd', gitsigns.diffthis, { desc = 'Diff index' })
        map('n', '<leader>gD', function()
          gitsigns.diffthis '@'
        end, { desc = 'Diff last commit' })
        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Line blame' })
        map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = 'Deleted' })
      end,
    },
  },
}
