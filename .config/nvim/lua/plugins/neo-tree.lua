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
    },
    window = {
      width = 30,
    },
  },
}
