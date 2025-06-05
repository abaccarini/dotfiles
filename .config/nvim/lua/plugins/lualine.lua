return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  -- opts = function(_, opts) -- This is the function that runs, AFTER loading
  opts = function() -- This is the function that runs, AFTER loading
    -- local trouble = require 'trouble'
    -- local symbols = trouble.statusline {
    --   mode = 'lsp_document_symbols',
    --   groups = {},
    --   title = false,
    --   filter = { range = true },
    --   format = '{kind_icon}{symbol.name:Normal}',
    --   -- The following line is needed to fix the background color
    --   -- Set it to the lualine section you want to use
    --   -- hl_group = 'None',
    --   -- hl_group = 'lualine_c_normal',
    -- }

    local function mode()
      -- Map of modes to their respective shorthand indicators
      local mode_map = {
        n = 'N', -- Normal mode
        i = 'I', -- Insert mode
        v = 'V', -- Visual mode
        [''] = 'V', -- Visual block mode
        V = 'V', -- Visual line mode
        c = 'C', -- Command-line mode
        no = 'N', -- NInsert mode
        s = 'S', -- Select mode
        S = 'S', -- Select line mode
        ic = 'I', -- Insert mode (completion)
        R = 'R', -- Replace mode
        Rv = 'R', -- Virtual Replace mode
        cv = 'C', -- Command-line mode
        ce = 'C', -- Ex mode
        r = 'R', -- Prompt mode
        rm = 'M', -- More mode
        ['r?'] = '?', -- Confirm mode
        ['!'] = '!', -- Shell mode
        t = 'T', -- Terminal mode
      }
      -- Return the mode shorthand or [UNKNOWN] if no match
      return mode_map[vim.fn.mode()] or '[UNKNOWN]'
    end
    local c_drac = require 'lualine.themes.dracula'
    local colors = require '../colors'

    c_drac.normal.c.bg = colors.menu
    c_drac.insert.c.bg = colors.menu
    c_drac.visual.c.bg = colors.menu
    c_drac.replace.c.bg = colors.menu
    c_drac.command.c.bg = colors.menu
    c_drac.inactive.c.bg = colors.menu

    c_drac.normal.a.bg = colors.menu
    c_drac.insert.a.bg = colors.menu
    c_drac.visual.a.bg = colors.menu
    c_drac.replace.a.bg = colors.menu
    c_drac.command.a.bg = colors.menu
    c_drac.inactive.a.bg = colors.menu

    c_drac.normal.a.fg = colors.purple
    c_drac.insert.a.fg = colors.green
    c_drac.visual.a.fg = colors.cyan
    c_drac.replace.a.fg = colors.red
    c_drac.command.a.fg = colors.orange
    c_drac.inactive.a.fg = colors.fg
    -- c_drac.normal.c.fg = colors['comment']
    -- c_drac.insert.c.fg = colors['comment']
    -- c_drac.visual.c.fg = colors['comment']
    -- c_drac.replace.c.fg = colors['comment']
    -- c_drac.command.c.fg = colors['comment']
    -- c_drac.inactive.c.fg = colors['comment']

    vim.o.shortmess = vim.o.shortmess .. 'S'
    require('lualine').setup {
      options = {
        icons_enabled = true,
        globalstatus = true,
        theme = c_drac,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        refresh = {
          statusline = 1,
          tabline = 1,
          winbar = 1,
        },
        -- section_separators = { left = '', right = '' },
      },
      --
      sections = {
        lualine_a = { mode },
        -- lualine_b = {
        --   { 'windows', use_mode_colors = true },
        -- },
        lualine_b = {},
        -- lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {
          -- { 'branch', icon = '', padding = { left = 0 } },
          { 'branch', icon = '' },

          {
            'diff',
            symbols = { added = ' ', modified = ' ', removed = ' ' },
            -- padding = { left = 0 },
          },
          { 'diagnostics', symbols = { error = ' ', warn = ' ', info = '', hint = ' ' } },
        },

        lualine_x = {
          { 'searchcount', draw_empty = true },
          { 'filetype', padding = { right = 0 }, colored = false, icon = '' },
          'progress',
          { 'location', padding = { right = 1 } },
          --
          -- function()
          --   local cur = vim.fn.line '.'
          --   local total = vim.fn.line '$'
          --   local col = vim.fn.virtcol '.' -- return '  ' .. os.date '%R'
          --   -- return string.format('%2d%%%% ☰ %d/%d  %d', math.floor(cur / total * 100), cur, total, col)
          --   -- return string.format('%d/%d  %d', cur, total, col)
          --   return string.format('%2d%%%% %d:%d', math.floor(cur / total * 100), cur, col)
          --   -- return string.format('☰ %d/%d  %d', cur, total, col)
          -- end,
        },
        lualine_y = {},
        lualine_z = {},
      },
      -- inactive_sections = {
      --   -- lualine_c = { 'filename' },
      --   lualine_y = { 'progress' },
      --   lualine_z = {  },
      -- },
      -- extenstions = { 'trouble' },
    }
  end,
}
