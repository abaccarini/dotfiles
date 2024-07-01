return {
  'ggandor/leap.nvim',
  dependencies = { 'tpope/vim-repeat', 'Mofiqul/dracula.nvim' },
  lazy = false,
  event = 'VimEnter',
  config = function()
    require('leap').create_default_mappings()

    local colors = require('dracula').colors()
    vim.api.nvim_create_augroup('LeapHighlights', { clear = false })
    vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
      group = 'LeapHighlights',
      pattern = { '*' },
      callback = function()
        vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' }) -- or some grey

        vim.api.nvim_set_hl(0, 'LeapMatch', {
          fg = colors['red'],
          bold = true,
          nocombine = true,
        })

        vim.api.nvim_set_hl(0, 'LeapLabelPrimary', {
          fg = colors['red'],
          bold = true,
          nocombine = true,
        })

        vim.api.nvim_set_hl(0, 'LeapLabelSecondary', {
          fg = colors['cyan'],
          bold = true,
          nocombine = true,
        })
      end,
    })
    vim.api.nvim_exec_autocmds('ColorScheme', { group = 'LeapHighlights' })
  end,
}
