return {

  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons',},
  config = function()
    -- local colors = require '../colors'
    -- calling `setup` is optional for customization
    require('fzf-lua').setup {
      files = {
        -- formatter = 'path.filename_first',
        -- hidden = true,
        -- find_opts = [[-type f -not -path '*/\.git/*' --exclude .git]],
        fd_opts = [[--color=never --hidden --type f --type l --exclude {*.axp,*.isy} ]],
      },

      -- file_ignore_patterns = { '%.idx$','%.pdf$', '%.bbl-SAVE-ERROR$' },
      winopts = {
        backdrop = 70,
      },
      -- actions = {
      lsp = {
        code_actions = {
          previewer = 'codeaction_native',
          preview_pager = 'delta --side-by-side --width=$FZF_PREVIEW_COLUMNS --file-style=omit',
        },

        -- symbols = {
        --   symbol_icons = icons.symbol_kinds,
        -- },
        -- },
      },
    }

    local fzf = require 'fzf-lua'
    fzf.register_ui_select() -- making fzf lua the default selection UI
    vim.keymap.set('n', '<leader><leader>', fzf.files, { desc = 'Search files' })
    vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = 'Search grep' })
    vim.keymap.set('n', '<leader>sr', fzf.resume, { desc = 'Search resume' })
    vim.keymap.set('n', '<leader>/', fzf.lgrep_curbuf, { desc = 'Search current buffer' })
    vim.keymap.set('n', '<leader>sb', fzf.buffers, { desc = 'Search buffers' })
    vim.keymap.set('n', '<leader>sD', fzf.diagnostics_document, { desc = 'Search diagnostics' })
    vim.keymap.set('n', '<leader>sk', fzf.keymaps, { desc = 'Search keymaps' })
    vim.keymap.set('n', '<leader>sh', fzf.helptags, { desc = 'Search help' })

    -- vim.keymap.set('n', '<leader>s/', '<cmd>FzfLua live_grep<CR>', { desc = 'Search [/] in Open Files' })

    -- vim.g.fzf_colors = { ['bg+'] = { 'bg', { 'ErrorMsg' }, 'bold', 'underline' } }
    -- vim.g.fzf_colors = { ['fg+'] = { 'fg', { 'Comment' } } }
    -- vim.g.fzf_colors = { ['bg+'] = { 'bg', "none" }}

    -- vim.api.nvim_set_hl(0, 'CursorColumn', { fg = colors['fg'], bg = colors['menu'] })
    -- vim.api.nvim_set_hl(0, 'FzfLuaBackdrop', { fg = 'none', bg = 'none' })
    vim.cmd [[
    let g:fzf_colors =
                \ { 'fg':    ['fg', 'Normal'],
                \ 'bg':      ['bg', 'Normal'],
                \ 'hl':      ['fg', 'Comment'],
                \ 'fg+':     ['fg', 'TestGroup', 'CursorColumn', 'Normal'],
                \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
                \ 'hl+':     ['fg', 'Statement'],
                \ 'gutter':  ['bg', 'Normal'],
                \ 'info':    ['fg', 'PreProc'],
                \ 'border':  ['fg', 'Ignore'],
                \ 'prompt':  ['fg', 'Conditional'],
                \ 'pointer': ['fg', 'Exception'],
                \ 'marker':  ['fg', 'Keyword'],
                \ 'spinner': ['fg', 'Label'],
                \ 'header':  ['fg', 'Comment'] }
          ]]
    -- vim.cmd.hi('TreesitterContextBottom gui=underline guisp=' .. colors['selection'])
  end,
}
