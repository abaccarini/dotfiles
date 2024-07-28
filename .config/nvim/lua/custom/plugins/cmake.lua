return {
  'Civitasv/cmake-tools.nvim',
  lazy = 'VeryLazy',

  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  init = function()
    local osys = require 'cmake-tools.osys'
    vim.keymap.set('n', '<C-B>', '<Cmd>CMakeBuild<CR>')

    require('cmake-tools').setup {
      cmake_virtual_text_support = false, -- Show the target related to current file using virtual text (at right corner)
      cmake_executor = {
        name = 'overseer',
        opts = {
          -- toggleterm = {
          --   direction = 'float', -- 'vertical' | 'horizontal' | 'tab' | 'float'
          --   close_on_exit = false, -- whether close the terminal when exit
          --   auto_scroll = true, -- whether auto scroll to the bottom
          --   singleton = true, -- single instance, autocloses the opened one, if present
          -- },

          -- new_task_opts = {
            -- strategy = {
            --   'toggleterm',
            --   direction = 'horizontal',
            --   quit_on_exit = 'never',
            --   open_on_start = true,
            --   auto_scroll = true,
            --   close_on_exit = true, -- whether close the terminal when exit
            --   -- quit_on_exit = 'success',
            -- },
          -- }, -- options to pass into the `overseer.new_task` command
          on_new_task = function(task)
            require('overseer').open { enter = false, direction = 'bottom' }
          end,
        },
        -- name = 'toggleterm',
        -- opts = {
        --   direction = 'horizontal', -- 'vertical' | 'horizontal' | 'tab' | 'float'
        --   close_on_exit = false, -- whether close the terminal when exit
        --   auto_scroll = true, -- whether auto scroll to the bottom
        -- },
      },
    }
  end,
}
