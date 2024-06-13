return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  -- opts = function(_, opts) -- This is the function that runs, AFTER loading
  opts = function() -- This is the function that runs, AFTER loading
    local trouble = require 'trouble'
    local symbols = trouble.statusline {
      mode = 'lsp_document_symbols',
      groups = {},
      title = false,
      filter = { range = true },
      format = '{kind_icon}{symbol.name:Normal}',
      -- The following line is needed to fix the background color
      -- Set it to the lualine section you want to use
      -- hl_group = 'Comment',
      hl_group = 'lualine_c_normal',
      -- hl_group = 'lualine_b_normal',
    }

    vim.o.shortmess = vim.o.shortmess .. 'S'
    require('lualine').setup {
      options = {
        icons_enabled = true,
        globalstatus = true,
        theme = 'auto',
        -- theme = custom_drac,
        component_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = '' },
      },
      --
      sections = {
        lualine_a = { 'mode' },
        -- lualine_b = {
        --   { 'windows', use_mode_colors = true },
        -- },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {
          { symbols.get, cond = symbols.has },
        },
        lualine_x = {
          { 'searchcount', draw_empty = true },
        },
        lualine_y = {
          -- { 'searchcount', draw_empty = true },
          { 'filetype' },
          -- {
          --   'fileformat',
          --   symbols = {
          --     unix = '', -- e712
          --     dos = '󰨡', -- e70f
          --     mac = '', -- e711
          --   },
          -- },
          -- 'encoding',
        },

        lualine_z = {
          -- 'progress',
          -- 'location',
          function()
            local cur = vim.fn.line '.'
            local total = vim.fn.line '$'
            local col = vim.fn.virtcol '.' -- return '  ' .. os.date '%R'
            return string.format('%2d%%%% ☰ %d/%d  %d', math.floor(cur / total * 100), cur, total, col)
            -- return string.format('☰ %d/%d  %d', cur, total, col)
          end,
        },
        -- lualine_z = {},
      },
      inactive_sections = {
        -- lualine_c = { 'filename' },
        -- lualine_x = { 'location' },
      },
      extenstions = { 'trouble' },
    }
  end,
}
