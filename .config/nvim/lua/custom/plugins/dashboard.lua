return {
  'nvimdev/dashboard-nvim',
  dependencies = {
    {
      'folke/persistence.nvim',
      event = 'BufReadPre',
      opts = {
        options = vim.opt.sessionoptions:get(),
        -- options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
        -- pre_save = function()
        --   local get_ls = vim.tbl_filter(function(buf)
        --     return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, 'buflisted')
        --   end, vim.api.nvim_list_bufs())

        pre_save = function()
          local bufs = vim.api.nvim_list_bufs()
          -- local current_buf = vim.api.nvim_get_current_buf()
          for _, i in ipairs(bufs) do
            local buf_name = vim.fn.bufname(i)
            if buf_name == '' then
              vim.api.nvim_buf_delete(i, {})
            end
          end
          -- local buf_name = vim.fn.bufname(buf_number)
          -- -- so we can edit the fugitive config file, while preventing the actual fugitive window from being shown
          -- if string.find(buf_name, 'fugitive') and not string.find(buf_name, 'fugitive.lua') then
          --   return false
          -- end

          -- local filetype = vim.bo[buf_number].filetype

          -- if filetype == '' and buf_name == '' then
          --   return false
          -- end
        end,
      },
      -- stylua: ignore
      -- keys = {
      --   { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      --   { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      --   { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
      -- },
    },
    {
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-telescope/telescope-project.nvim',
    },
  },
  event = 'VimEnter',
  opts = function()
    vim.keymap.set('n', '<leader>pd', vim.cmd.Dashboard, { desc = 'Open Dashboard' })
    local logo = {
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                     ]],
      [[       ████ ██████           █████      ██                     ]],
      [[      ███████████             █████                             ]],
      [[      █████████ ███████████████████ ███   ███████████   ]],
      [[     █████████  ███    █████████████ █████ ██████████████   ]],
      [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
    }
    local telescope_fn = function()
      require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
    end
    local opts = {
      theme = 'doom',
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },
      config = {
        header = logo,
        -- stylua: ignore

      -- vim.keymap.set('n', '<leader>sn', function()
      --   builtin.find_files { cwd = vim.fn.stdpath 'config' }
      -- end, { desc = '[S]earch [N]eovim files' })
        center = {
          { action = "Telescope project",                                        desc = " Open Project",    icon = " ", key = "p" },
          { action = "Telescope find_files cwd=",                                desc = " Find File",       icon = "󱀶 ", key = "f" },
          { action = "ene | startinsert",                                        desc = " New File",        icon = " ", key = "n" },
          { action = "Telescope oldfiles",                                       desc = " Recent Files",    icon = " ", key = "r" },
          { action = "Telescope live_grep",                                      desc = " Find Text",       icon = " ", key = "g" },
          { action = 'lua require("persistence").load()',                        desc = " Restore Session", icon = " ", key = "s" },
          { action = "Lazy",                                                     desc = " Lazy",            icon = "󰒲 ", key = "l" },
          { action = telescope_fn,                                               desc = " Open Config",     icon = " ", key = "c" },
          { action = "qa",                                                       desc = " Quit",            icon = " ", key = "q" },
        },
        footer = function()
          local stats = require('lazy').stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms' }
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(' ', 43 - #button.desc)
      button.key_format = '  %s'
    end

    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == 'lazy' then
      vim.cmd.close()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'DashboardLoaded',
        callback = function()
          require('lazy').show()
        end,
      })
    end

    return opts
  end,
}
