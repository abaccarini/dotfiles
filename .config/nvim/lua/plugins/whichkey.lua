return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  -- enabled = false,
  -- dependencies = { {'echasnovski/mini.icons', version = false} },
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show { global = false }
      end,
      desc = 'Show local keymaps',
    },
  },
  config = function() -- This is the function that runs, AFTER loading
    require('which-key').setup {
      preset = 'helix',
      delay = 0,
      icons = {
        colors = true,
      },
      triggers = {
        { '<auto>', mode = 'nso' },
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
