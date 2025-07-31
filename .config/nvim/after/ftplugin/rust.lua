local bufnr = vim.api.nvim_get_current_buf()

-- vim.keymap.set('n', 'J', function()
--   vim.cmd.RustLsp 'joinLines'
-- end, { silent = true, buffer = bufnr })

vim.keymap.set('n', '<leader>dt', function()
  vim.cmd.RustLsp 'testables'
end, { desc = 'Debugger testables' })

vim.keymap.set('n', '<space>a', '<Plug>RustHoverAction')
