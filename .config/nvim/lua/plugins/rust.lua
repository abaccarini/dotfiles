return {
  {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
    ft = 'rust',
    config = function()
        vim.g.rustaceanvim = {
            tools = {
                float_win_config = {
                    border = 'rounded'
                }
            },
            -- server = {
            --     on_attach = require("lvim.lsp").common_on_attach
            -- },
        }
    end,
  },

  {
    'rust-lang/rust.vim',
    ft = 'rust',
    config = function()
    end
  },

  {
    'saecki/crates.nvim',
    ft = { 'toml' },
    config = function()
      require('crates').setup {
        completion = {
          cmp = {
            enabled = true,
          },
        },
      }
      require('cmp').setup.buffer {
        sources = { { name = 'crates' } },
      }
    end,
  },
  -- {
  --   'cordx56/rustowl',
  --   dependencies = { 'neovim/nvim-lspconfig' },
  --   config = function()
  --     -- require('lspconfig').rustowlsp.setup {
  --     -- }
  --   end,
  -- },
}
