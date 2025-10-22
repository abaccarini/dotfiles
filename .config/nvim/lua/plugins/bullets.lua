return {
  'bullets-vim/bullets.vim',
  -- enabled=false
  -- name = 'barbecue',
  -- version = '*',
  -- dependencies = {
  --   'SmiteshP/nvim-navic',
  --   'nvim-tree/nvim-web-devicons', -- optional dependency
  -- },
  init = function()
    vim.cmd [[
let g:bullets_custom_mappings = [
 \ ['imap', '<cr>', '<Plug>(bullets-newline)'],
  \ ['inoremap', '<C-cr>', '<cr>'],
  \
  \ ['nmap', 'o', '<Plug>(bullets-newline)'],
  \
  \ ['vmap', 'gN', '<Plug>(bullets-renumber)'],
  \ ['nmap', 'gN', '<Plug>(bullets-renumber)'],
  \
  \ ['nmap', '<leader>x', '<Plug>(bullets-toggle-checkbox)'],
  \
  \ ['imap', '<C-t>', '<Plug>(bullets-demote)'],
  \ ['nmap', '>>', '<Plug>(bullets-demote)'],
  \ ['vmap', '>', '<Plug>(bullets-demote)'],
  \ ['imap', '<C-d>', '<Plug>(bullets-promote)'],
  \ ['nmap', '<<', '<Plug>(bullets-promote)'],
  \ ['vmap', '<', '<Plug>(bullets-promote)'],
  \ ['imap', '<Tab>', '<Plug>(bullets-demote)'],
  \ ['imap', '<S-Tab>', '<Plug>(bullets-promote)'],
  \ ]
      ]]
  end,
}
