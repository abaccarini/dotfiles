return {
  {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
    ft = 'rust',
    config = function()
      vim.g.rustaceanvim = {
        tools = {
          float_win_config = {
            border = 'rounded',
          },
        },
      }

      local bufnr = vim.api.nvim_get_current_buf()

      vim.keymap.set(
        'n',
        'K', -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
        function()
          vim.cmd.RustLsp { 'hover', 'actions' }
        end,
        { silent = true,desc = 'Rust hover'}
      )

      vim.keymap.set('n', 'J', function()
        vim.cmd.RustLsp 'joinLines'
      end, { silent = true, buffer = bufnr })

      vim.keymap.set('n', '<Leader>dt', function()
        vim.cmd.RustLsp 'testables'
      end, { desc = 'Debugger testables' })
      -- map("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })
    end,
  },

  {
    'rust-lang/rust.vim',
    ft = 'rust',
    config = function() end,
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
