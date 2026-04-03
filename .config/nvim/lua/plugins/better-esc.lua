return {

  'max397574/better-escape.nvim',
  -- enabled = false,
  config = function()
    require('better_escape').setup {
      mappings = {
        t = {
          j = {
            k = '<Esc>',
          },
        },
      },
    }
  end,
}
