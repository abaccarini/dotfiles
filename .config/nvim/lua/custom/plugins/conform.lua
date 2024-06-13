return { -- Autoformat
  'stevearc/conform.nvim',
  lazy = false,
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = false,
    -- format_on_save = function(bufnr)
    --   -- Disable "format_on_save lsp_fallback" for languages that don't
    --   -- have a well standardized coding style. You can add additional
    --   -- languages here or re-enable it for the disabled ones.
    --   local disable_filetypes = { c = true, cpp = true }
    --   return {
    --     timeout_ms = 500,
    --     lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
    --   }
    -- end,

    formatters = {
      latexindent = {
        -- Change where to find the command
        command = function()
          if vim.loop.os_uname().sysname == 'Darwin' then
            return '/Library/TeX/texbin/latexindent'
          else
            return '/usr/local/texlive/2023/bin/x86_64-linux/latexindent'
          end
        end,
        -- Adds environment args to the yamlfix formatter
        -- env = {
        --   YAMLFIX_SEQUENCE_STYLE = 'block_style',
        -- },
      },
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      -- Conform can also run multiple formatters sequentially
      python = { 'black' },
      cpp = { 'clang-format' },
      tex = { 'latexindent' },
      --
      -- You can use a sub-list to tell conform to run *until* a formatter
      -- is found.
      -- javascript = { { "prettierd", "prettier" } },
    },
  },
}
