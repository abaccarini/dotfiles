return {

  'max397574/better-escape.nvim',
  config = function()
    require('better_escape').setup {
      -- mapping = { 'jj' }, -- a table with mappings to use
      -- mappings = {
      --   i = {
      --     j = {
      --       -- These can all also be functions
      --       k = '<Esc>',
      --       j = '<Esc>',
      --     },
      --   },

      -- },
    }
  end,
}
