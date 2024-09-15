return {

  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons', { 'Mofiqul/dracula.nvim' } },
  config = function()
    local dracula = require 'dracula'
    local colors = dracula.colors()
    -- calling `setup` is optional for customization
    require('fzf-lua').setup {
      winopts = {
        backdrop = 100,
      },
    }
    vim.keymap.set('n', '<leader><leader>', '<cmd>FzfLua files<CR>')
    -- vim.g.fzf_colors = { ['bg+'] = { 'bg', { 'ErrorMsg' }, 'bold', 'underline' } }
    -- vim.g.fzf_colors = { ['fg+'] = { 'fg', { 'Comment' } } }
    -- vim.g.fzf_colors = { ['bg+'] = { 'bg', "none" }}

    -- vim.api.nvim_set_hl(0, 'CursorColumn', { fg = colors['fg'], bg = colors['menu'] })
    -- vim.api.nvim_set_hl(0, 'FzfLuaBackdrop', { fg = 'none', bg = 'none' })
    vim.cmd [[
    let g:fzf_colors =
                \ { 'fg':      ['fg', 'Normal'],
                \ 'bg':      ['bg', 'Normal'],
                \ 'hl':      ['fg', 'Comment'],
                \ 'fg+':     ['fg', 'TestGroup', 'CursorColumn', 'Normal'],
                \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
                \ 'hl+':     ['fg', 'Statement'],
                \ 'gutter':     ['bg', 'Normal'],
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
