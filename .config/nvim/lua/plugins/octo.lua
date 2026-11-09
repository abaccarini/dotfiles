return {
  'pwntester/octo.nvim',
  cmd = 'Octo',
  opts = {
    -- or "fzf-lua" or "snacks" or "default"
    picker = 'fzf-lua',
    -- bare Octo command opens picker of commands
    enable_builtin = true,
  },
  config = function(_, opts)
    require('octo').setup(opts)

    -- The fzf-lua PR list shows a stacked PR as "<num> <title>  ⧉ N/M" but files it
    -- under "<num> <title>", so previewing or opening one indexes nil
    -- (pwntester/octo.nvim#1574). The previewer and actions share that table: on a
    -- miss, retry without the suffix. Once upstream keys it by the shown line, lookups
    -- stop missing and this is a no-op.
    local previewers = require 'octo.pickers.fzf-lua.previewers'
    local issue_previewer = previewers.issue
    previewers.issue = function(formatted_items)
      setmetatable(formatted_items, {
        __index = function(items, line)
          local plain = type(line) == 'string' and line:match '^(.-)  ⧉ %d+/%d+$'
          if plain then
            return rawget(items, plain)
          end
        end,
      })
      return issue_previewer(formatted_items)
    end
  end,
  keys = {
    {
      '<leader>oi',
      '<CMD>Octo issue list<CR>',
      desc = 'List GitHub Issues',
    },
    {
      '<leader>op',
      '<CMD>Octo pr list<CR>',
      desc = 'List GitHub PullRequests',
    },
    {
      '<leader>od',
      '<CMD>Octo discussion list<CR>',
      desc = 'List GitHub Discussions',
    },
    {
      '<leader>on',
      '<CMD>Octo notification list<CR>',
      desc = 'List GitHub Notifications',
    },
    {
      '<leader>os',
      function()
        require('octo.utils').create_base_search_command { include_current_repo = true }
      end,
      desc = 'Search GitHub',
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
     "ibhagwan/fzf-lua",
    -- OR "folke/snacks.nvim",
    'nvim-tree/nvim-web-devicons', -- optional if file_panel.icons is a function
  },
}
