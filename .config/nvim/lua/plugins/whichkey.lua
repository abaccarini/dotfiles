return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  -- enabled = false,
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
      defer = function()
        -- return
      end,
      win = {
        width = { min = 25, max = 40 },
      },
      spec = {
        {
          { 'MouseMove', hidden = true, name = 'which_key_ignore', desc = 'which_key_ignore' },
          { 'MouseMove_', hidden = true, name = 'which_key_ignore', desc = 'which_key_ignore' },
        },
      },
    }

    local colors = require 'colors'
    local hl = vim.api.nvim_set_hl

    hl(0, 'WhichKeyIconCyan', { fg = colors.cyan })
    hl(0, 'WhichKeyIconBlue', { fg = colors.cyan })
    hl(0, 'WhichKeyIconAzure', { fg = colors.bright_magenta })
    hl(0, 'WhichKeyIconGreen', { fg = colors.green })
    hl(0, 'WhichKeyIconGrey', { fg = colors.comment })
    hl(0, 'WhichKeyIconOrange', { fg = colors.orange })
    hl(0, 'WhichKeyIconPurple', { fg = colors.purple })
    hl(0, 'WhichKeyIconRed', { fg = colors.red })
    hl(0, 'WhichKeyIconYellow', { fg = colors.yellow })

    local help = { icon = '', color = 'green' }
    local diag = { icon = ' ', color = 'red' }
    local buff = { icon = '󰓩 ', color = 'azure' }
    local wk = require 'which-key'
    wk.add {

      { '<leader>;', icon = { icon = '//', color = 'grey' } },

      { '<leader>gR', icon = { icon = ' ', color = 'red' } },
      { '<leader>gd', icon = { icon = '', color = 'cyan' } },
      { '<leader>gD', icon = { icon = ' ', color = 'cyan' } },
      { '<leader>gp', icon = { icon = '', color = 'purple' } },
      { '<leader>gb', icon = { icon = ' ', color = 'orange' } },
      { '<leader>gS', icon = { icon = '', color = 'green' } },
      { '<leader>gs', icon = { icon = '󱖫 ', color = 'azure' } },

      { '<leader>d', group = 'Debug', icon = { icon = '󰃤 ', color = 'red' } },

      { '<leader>b', group = 'Buffer', icon = buff },
      { '<leader>bd', icon = { icon = ' ', color = 'red' } },
      { '<leader>bh', icon = { icon = ' ', color = 'red' } },
      { '<leader>bl', icon = { icon = ' ', color = 'red' } },
      { '<leader>bo', icon = { icon = ' ', color = 'red' } },

      { '<leader>r', group = 'Rename', icon = { icon = ' ' } },
      { '<leader>rn', group = 'Rename', icon = { icon = ' ' } },

      { '<leader>x', group = 'Trouble', icon = { icon = ' ' } },

      { '<leader><leader>', icon = { icon = ' ', color = 'purple' } },
      { '<leader>s', group = 'Search', icon = { icon = ' ', color = 'purple' } },
      { '<leader>sh', icon = help },
      { '<leader>sD', icon = diag },
      { '<leader>sr', icon = { icon = ' ', color = 'orange' } },
      { '<leader>sg', icon = { icon = '󱎸 ', color = 'purple' } },
      { '<leader>sk', icon = { icon = ' ', color = 'yellow' } },
      { '<leader>sb', icon = buff },

      { '<leader>j', group = 'Jump', icon = { icon = ' ', color = 'cyan' } },

      { '<leader>?', icon = help },

      { '<leader>p', group = 'Project', icon = { icon = '󰍹 ', color = 'purple' } },
      { '<leader>ps', icon = { icon = '󰀫 ', color = 'green' } },

      { '<leader>w', icon = { icon = ' ', color = 'red' } },

      { '<leader>f', icon = { icon = '󰉠 ', color = 'yellow' } },

      { '<leader>t', group = 'Toggle', icon = { icon = ' ', color = 'yellow' } },
      { '<leader>tb', icon = { icon = ' ', color = 'orange' } },
      { '<leader>td', icon = diag },
      { '<leader>tD', icon = { icon = '󰛌', color = 'yellow' } },
      { '<leader>th', icon = { icon = ' ', color = 'cyan' } },
      { '<leader>tu', icon = { icon = ' ', color = 'green' } },

      {
        mode = { 'n', 'v' }, -- NORMAL and VISUAL mode

        { '<leader>g', group = 'Git', icon = { icon = '󰊢 ', color = 'orange' } },
        { '<leader>gh', group = 'Hunk', icon = { icon = ' ', color = 'yellow' } },
        { '<leader>ghs', icon = { icon = '', color = 'green' } },
        { '<leader>ghr', icon = { icon = ' ', color = 'red' } },
        { '<leader>ghp', icon = { icon = ' ', color = 'cyan' } },
        { '<leader>ghu', icon = { icon = ' ', color = 'azure' } },
      },
      {
        mode = { 'n', 'v', 'o', 'x' }, -- NORMAL and VISUAL mode
        { '<MouseMove>', hidden = true }, -- no need to specify mode since it's inherited
      },
    }
  end,
}
