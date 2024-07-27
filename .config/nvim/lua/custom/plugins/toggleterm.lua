return {
  'akinsho/toggleterm.nvim',
  version = '*',
  opts = {--[[ things you want to change go here]]
  },
  init = function()
    require('toggleterm').setup {
      shade_terminals = false,
      highlights = {
        Normal = {
          -- guibg = "none",
        },
      },
    }
  end,
}
