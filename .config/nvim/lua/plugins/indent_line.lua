return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  -- enabled = false,
  opts = {
    exclude = { filetypes = { 'dashboard' } },
    scope = { enabled = true },
  },
  config = function()
    require('ibl').setup {
      exclude = { filetypes = { 'dashboard' } },
      scope = { enabled = true },
      -- show_current_context = true,
      -- show_current_context_start = true,
    }
  end,
}
