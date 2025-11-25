return { -- Autoformat
  'stevearc/conform.nvim',
  lazy = false,
  keys = {
    {
      '<leader>f',
      -- '<C-S-i>',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = 'n',
      desc = 'Format buffer',
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
      rustfmt = {
        command = 'rustfmt',
        -- A list of strings, or a function that returns a list of strings
        -- Return a single string instead of a list to run the command in a shell
        -- args = { '+nightly' },
      },
      latexindent = {
        -- Change where to find the command
        prepend_args = { '-l' },
        command = function()
          if vim.loop.os_uname().sysname == 'Darwin' then
            return '/Library/TeX/texbin/latexindent'
          else
            return '/usr/local/texlive/2024/bin/x86_64-linux/latexindent'
          end
        end,
        -- Adds environment args to the yamlfix formatter
        -- env = {
        --   YAMLFIX_SEQUENCE_STYLE = 'block_style',
        -- },
      },
    },
    formatters_by_ft = {
      rust = { 'rustfmt' },
      lua = { 'stylua' },
      -- Conform can also run multiple formatters sequentially
      python = { 'black' },
      cpp = { 'clang-format' },
      tex = { 'latexindent' },
      bib = { 'bibtex-tidy' },
      markdown = { 'markdownlint' },
      javascript = { 'prettier' },
      html = { 'prettier' },
      toml = { 'taplo' },
      --
      -- You can use a sub-list to tell conform to run *until* a formatter
      -- is found.
      -- javascript = { { "prettierd", "prettier" } },
    },
  },
}
