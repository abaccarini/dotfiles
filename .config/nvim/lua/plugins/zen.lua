-- Lua
return {
  'folke/zen-mode.nvim',

  -- enabled=false,
  config = function()
    vim.keymap.set('n', '<leader>z', '<Cmd>ZenMode<CR>')

    require('zen-mode').setup {
      window = {
        backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
        -- height and width can be:
        -- * an absolute number of cells when > 1
        -- * a percentage of the width / height of the editor when <= 1
        -- * a function that returns the width or the height

        width = 80, -- width of the Zen window
      },
      plugins = {
        options = {
          laststatus = 0,
        },
      },
    }
  end,
}
