return {
  'nvimdev/dashboard-nvim',
  dependencies = {
    {
      'folke/persistence.nvim',
      event = 'BufReadPre',
      opts = { options = vim.opt.sessionoptions:get() },
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
