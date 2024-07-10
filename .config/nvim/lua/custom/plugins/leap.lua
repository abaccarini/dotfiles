return {
  'ggandor/leap.nvim',
  dependencies = { 'tpope/vim-repeat', 'Mofiqul/dracula.nvim' },
  enabled = false,
  lazy = false,
  event = 'VimEnter',
  config = function()
    -- require('leap').create_default_mappings()
    vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap-forward)')
    vim.keymap.set({ 'n', 'x', 'o' }, '<leader>jS', '<Plug>(leap-backward)')
    -- vim.keymap.set({ 'n', 'x', 'o' }, 'gs', '<Plug>(leap-from-window)')
  -- vim.keymap.set('n',        '<leader>jj', '<Plug>(leap)')
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
