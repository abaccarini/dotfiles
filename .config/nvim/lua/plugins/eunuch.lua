return {
  'tpope/vim-eunuch',
  -- enabled=false,
  config = function()
    vim.cmd 'cnoreabbrev rename Rename'
  end,
}
