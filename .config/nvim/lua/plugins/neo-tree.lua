return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '<C-\\>', ':Neotree toggle<CR>', silent = true, { desc = 'Toggle Neotree' } },
  },
  opts = {
    sort_case_insensitive = true,
    close_if_last_window = true,
    filesystem = {
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
        leave_dirs_open = true,
      },
      filtered_items = {
        visible = false,
        hide_gitignored = true,
        hide_dotfiles = false,
        hide_by_name = {
          '.github',
          '.gitignore',
          'package-lock.json',
          '.changeset',
          '.prettierrc.json',
        },
        never_show = { '.git' },
      },
    },
    window = {
      bind_to_cwd = false, -- true creates a 2-way binding between vim's cwd and neo-tree's root
      width = 30,
      mappings = {
        -- ["/"] = "noop"
      },
      fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
        -- ["<down>"] = "move_cursor_down",
        ['<C-n>'] = 'move_cursor_down',
        -- ["<up>"] = "move_cursor_up",
        ['<C-S-n>'] = 'move_cursor_up',
        -- ["<esc>"] = "close",
        -- ["<S-CR>"] = "close_keep_filter",
        -- ["<C-CR>"] = "close_clear_filter",
        -- ["<C-w>"] = { "<C-S-w>", raw = true },
      },
    },

    event_handlers = {

      {
        event = 'file_open_requested',
        handler = function()
          -- auto close
          -- vim.cmd("Neotree close")
          -- OR
          require('neo-tree.command').execute { action = 'close' }
        end,
      },
    },
  },
}
