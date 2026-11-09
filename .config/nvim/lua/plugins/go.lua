return {
  'ray-x/go.nvim',
  dependencies = { -- optional packages
    'ray-x/guihua.lua',
    'neovim/nvim-lspconfig',
    -- { "nvim-treesitter/nvim-treesitter", branch = 'main' } -- optional for master version
  },
  opts = function()
    -- go.nvim's textobjects call nvim-treesitter's configs.setup() again, which wipes
    -- init.lua's ignore_install (bringing back the latex auto-install error). init.lua
    -- configures textobjects itself, including the ]] [[ jumps this used to add.
    require('go').setup { textobjects = false }
    local format_sync_grp = vim.api.nvim_create_augroup('GoFormat', {})
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*.go',
      callback = function()
        require('go.format').goimports()
      end,
      group = format_sync_grp,
    })
    return {
      -- lsp_keymaps = false,
      -- other options
    }
  end,
  event = { 'CmdlineEnter' },
  ft = { 'go', 'gomod' },
  build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
}
