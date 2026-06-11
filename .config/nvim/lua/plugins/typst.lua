return {
  'kaarmu/typst.vim',
  ft = 'typst',
  -- enabled = false,
  lazy = false,
  -- config = function()
  -- require('lspconfig')['tinymist'].setup { -- Alternatively, can be used `vim.lsp.config["tinymist"]`
  --   on_attach = function(client, bufnr)
  --     vim.keymap.set('n', '<leader>tp', function()
  --       client:exec_cmd({
  --         title = 'pin',
  --         command = 'tinymist.pinMain',
  --         arguments = { vim.api.nvim_buf_get_name(0) },
  --       }, { bufnr = bufnr })
  --     end, { desc = '[T]inymist [P]in', noremap = true })
  --     vim.keymap.set('n', '<leader>tu', function()
  --       client:exec_cmd({
  --         title = 'unpin',
  --         command = 'tinymist.pinMain',
  --         arguments = { vim.v.null },
  --       }, { bufnr = bufnr })
  --     end, { desc = '[T]inymist [U]npin', noremap = true })
  --   end,
  -- }

  --   vim.api.nvim_create_user_command('OpenPdf', function()
  --     local filepath = vim.api.nvim_buf_get_name(0)
  --     if filepath:match '%.typ$' then
  --       local pdf_path = filepath:gsub('%.typ$', '.pdf')
  --       vim.system { 'open', pdf_path }
  --     end
  --   end, {})
  -- local function git_root()
  --   return vim.fn.fnamemodify(vim.fn.finddir('.git', ';'), ':h')
  -- end

  -- local function typst_watch()
  --   vim.cmd 'vsp'
  --   vim.cmd 'vertical resize 20'
  --   vim.cmd('terminal typst watch --root ' .. git_root() .. ' ' .. vim.fn.expand '%:')
  --   vim.cmd 'wincmd h'
  -- end

  -- vim.keymap.set('n', '<leader>fc', typst_watch, { silent = true })

  -- vim.keymap.set('n', '<leader>fr', function()
  --   vim.cmd('silent !zathura --fork ' .. vim.fn.expand '%:p:r' .. '.pdf &')
  -- end, { silent = true })
  -- end,
}
