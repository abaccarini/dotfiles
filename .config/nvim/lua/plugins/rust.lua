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
        lsp = {
          enabled = true,
          on_attach = function(client, bufnr)
            -- the same on_attach function as for your other lsp's
          end,
          actions = true,
          completion = true,
          hover = true,
        },
        completion = {
          blink = {
            use_custom_kind = true,
            kind_text = {
              version = 'Version',
              feature = 'Feature',
            },
            kind_highlight = {
              version = 'BlinkCmpKindVersion',
              feature = 'BlinkCmpKindFeature',
            },
            kind_icon = {
              version = ' ',
              feature = ' ',
            },
          },
        },
      }
      local crates = require 'crates'
      -- local {desc=""} = { silent = true }

      local wk = require 'which-key'

      wk.add {
        { mode = {'n', 'v'}, '<leader>c', group = 'Crates', icon = { icon = '󰏗 ', color = 'orange' } },
        { mode = 'n', '<leader>ct', crates.toggle, desc = 'Toggle', },
        { mode = 'n', '<leader>cr', crates.reload, desc = 'Reload', icon = { icon = ' ', color = 'blue' } },

        { mode = 'n', '<leader>cv', crates.show_versions_popup, desc = 'Show Versions', icon = { icon = '', color = 'purple' } },
        { mode = 'n', '<leader>cf', crates.show_features_popup, desc = 'Show Features', icon = { icon = ' ', color = 'yellow' } },
        { mode = 'n', '<leader>cd', crates.show_dependencies_popup, desc = 'Show Deps', icon = { icon = ' ', color = 'orange' } },

        { mode = 'n', '<leader>cu', crates.update_crate, desc = 'Update', icon = { icon = ' ', color = 'green' } },
        { mode = 'n', '<leader>ca', crates.update_all_crates, desc = 'Update All', icon = { icon = ' ', color = 'green' } },
        { mode = 'v', '<leader>cu', crates.update_crates, desc = 'Update', icon = { icon = ' ', color = 'green' } },

        { mode = 'n', '<leader>cU', crates.upgrade_crate, desc = 'Upgrade', icon = { icon = ' ', color = 'red' } },
        { mode = 'n', '<leader>cA', crates.upgrade_all_crates, desc = 'Upgrade All', icon = { icon = ' ', color = 'red' } },
        { mode = 'v', '<leader>cU', crates.upgrade_crates, desc = 'Upgrade', icon = { icon = ' ', color = 'red' } },

        { mode = 'n', '<leader>cx', crates.expand_plain_crate_to_inline_table, desc = 'Expand Crate to Table', icon = { icon = ' ', color = 'cyan' } },
        { mode = 'n', '<leader>cX', crates.extract_crate_into_table, desc = 'Extract Crate to Table', icon = { icon = ' ', color = 'cyan' } },

        { mode = 'n', '<leader>cH', crates.open_homepage, desc = 'Homepage', icon = { icon = '󰖟 ', color = 'blue' } },
        { mode = 'n', '<leader>cR', crates.open_repository, desc = 'Repository', icon = { icon = '󰊢 ', color = 'green' } },
        { mode = 'n', '<leader>cD', crates.open_documentation, desc = 'Documentation', icon = { icon = ' ', color = 'azure' } },
        { mode = 'n', '<leader>cC', crates.open_crates_io, desc = 'crates.io', icon = { icon = '󰏖 ', color = 'orange' } },
        { mode = 'n', '<leader>cL', crates.open_lib_rs, desc = 'lib.rs', icon = { icon = ' ', color = 'green' } },
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
