return {
  'j-hui/fidget.nvim',
  enabled = false,
  opts = {
    progress = {
      suppress_on_insert = true, -- Suppress new messages while in insert mode
      display = {
        render_limit = 2, -- How many LSP messages to show at once
        done_ttl = 1, -- How long a message should persist after completion
      },
    },
  },
}
