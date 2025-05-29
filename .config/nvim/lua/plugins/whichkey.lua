return { -- Useful plugin to show you pending keybinds.
  -- enabled = false,
  'folke/which-key.nvim',
  -- dependencies = { {'echasnovski/mini.icons', version = false} },
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show { global = false }
      end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
  },
  config = function() -- This is the function that runs, AFTER loading
    -- vim.keymap.set('n', '<leader>S', 'z=', {remap = true})
    -- vim.keymap.set('n', '<leader>Sa', 'zg', {remap = true})
    -- vim.keymap.set('n', '<leader>su', 'zug', {remap = true})
    require('which-key').setup {
      preset = 'helix',
      icons = {
        colors = true,
      },
      -- keys = {
      --   scroll_up = '<c-k>', -- binding to scroll up inside the popup
      --   scroll_down = '<c-j>', -- binding to scroll down inside the popup
      -- },
    }

    -- Document existing key chains
    -- require('which-key').register {
    --   ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
    --   ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
    --   ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
    --   ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
    --   -- ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
    --   ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
    -- }
  end,
}
