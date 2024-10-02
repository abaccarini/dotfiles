return {
  'Civitasv/cmake-tools.nvim',
  -- lazy = 'VeryLazy',
  ft = 'cpp',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    -- local osys = require 'cmake-tools.osys'
    -- vim.api.nvim_create_user_command('OverseerRestartLast', function()
    --   local overseer = require 'overseer'
    --   local tasks = overseer.list_tasks { recent_first = true }
    --   if vim.tbl_isempty(tasks) then
    --     vim.notify('No tasks found', vim.log.levels.WARN)
    --   else
    --     overseer.run_action(tasks[1], 'restart')
    --   end
    -- end, {})
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'cpp',
      callback = function(event)
        vim.keymap.set('n', '<C-b>', '<Cmd>CMakeBuild<CR>')
        vim.keymap.set('n', '<C-c>', '<Cmd>CMakeSelectBuildType<CR>')
      end,
    })
    require('cmake-tools').setup {
      cmake_virtual_text_support = false, -- Show the target related to current file using virtual text (at right corner)
  -- cmake_soft_link_compile_commands = false, -- this will automatically make a soft link from compile commands file to project root dir
  -- cmake_compile_commands_from_lsp = true, --
      -- cmake_executor = {
      --   name = "toggleterm",
      --   opts = {
      --     direction = "horizontal", -- 'vertical' | 'horizontal' | 'tab' | 'float'
      --   close_on_exit = false, -- whether close the terminal when exit
      --   auto_scroll = true, -- whether auto scroll to the bottom

      --   }

    -- }
      cmake_executor = {
        name = 'overseer',
        opts = {
          on_new_task = function(task)
            require('overseer').open { enter = false, direction = 'bottom' }
          end,
        },
      },
    }
  end,
}
