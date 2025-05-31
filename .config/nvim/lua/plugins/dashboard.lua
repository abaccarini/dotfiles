return {
  'nvimdev/dashboard-nvim',
  dependencies = {
    {
      'folke/persistence.nvim',
      event = 'BufReadPre',

      opts = {
        dir = vim.fn.expand '$HOME/nvim_sessions/',
        options = vim.opt.sessionoptions:get(),
      },

      -- config = function()
      --   vim.api.nvim_create_autocmd('VimEnter', {

      --     callback = function()
      --       if vim.fn.getcwd() ~= vim.env.HOME then
      --         require('persistence').load()
      --         vim.cmd [[Neotree filesystem show]]
      --       end
      --     end,
      --     nested = true,
      --   })
      -- require('persistence').setup()
      -- end,
    },
    {
      'ibhagwan/fzf-lua',
    },
  },
  event = 'VimEnter',
  opts = function()
    local dracula = require 'dracula'
    local colors = dracula.colors()
    vim.api.nvim_set_hl(0, 'DashboardHeader', { fg = colors['comment'] })
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
      -- [[                                                                       ]],
      -- [[                                                                       ]],
    }
    local icon_color = 'IconColor'
    local key_color = 'KeyColor'
    local opts = {
      theme = 'doom',
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },
      config = {
        header = logo,

        center = {
          -- { action = "Telescope project",                                        desc = " Open Project",    icon = " ", key = "p" },
          { action = 'FzfLua files', desc = ' Find File', icon = ' ', key = 'f', icon_hl = icon_color, key_hl = key_color },
          { action = 'ene | startinsert', desc = ' New File', icon = ' ', key = 'n', icon_hl = icon_color, key_hl = key_color },
          { action = 'FzfLua oldfiles', desc = ' Recent Files', icon = ' ', key = 'r', icon_hl = icon_color, key_hl = key_color },
          { action = 'FzfLua live_grep', desc = ' Find Text', icon = ' ', key = 'g', icon_hl = icon_color, key_hl = key_color },
          { action = 'lua require("persistence").load()', desc = ' Restore Session', icon = ' ', key = 's', icon_hl = icon_color, key_hl = key_color },
          { action = 'Lazy', desc = ' Lazy', icon = '󰒲 ', key = 'l', icon_hl = icon_color, key_hl = key_color },
          { action = 'qa', desc = ' Quit', icon = ' ', key = 'q', icon_hl = icon_color, key_hl = key_color },
        },
        footer = function()
          local stats = require('lazy').stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { '⚡ Loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms' }
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
