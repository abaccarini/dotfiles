return {

  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- macOS: stdpath('run') lives under the long $TMPDIR path, and nvim appends
    -- `.<pid>.<seq>` to a *relative* server name -- which overflows sun_path's
    -- 104-byte limit, so fzf-lua's own serverstart() dies with EINVAL. Pre-start
    -- the RPC server on a short absolute path so fzf-lua's guard short-circuits.
    if not vim.g.fzf_lua_server then
      local dir = ('/tmp/nvim-%s'):format(vim.env.USER or 'nvim')
      pcall(vim.fn.mkdir, dir, 'p', tonumber('700', 8))
      local ok, srv = pcall(vim.fn.serverstart, ('%s/fzf-lua.%d'):format(dir, vim.fn.getpid()))
      if ok then
        vim.g.fzf_lua_server = srv
      end
    end

    -- local colors = require 'colors'
    -- calling `setup` is optional for customization
    require('fzf-lua').setup {
      files = {
        -- formatter = 'path.filename_first',
        -- hidden = true,
        -- find_opts = [[-type f -not -path '*/\.git/*' --exclude .git]],
        fd_opts = [[--color=never --hidden --type f --type l ]],
      },
      grep = {
        -- fzf-lua's default plus a Cargo.lock exclude (at any depth; a buffer's own
        -- path is still searched). This replaces the default, and `-e` must stay last.
        rg_opts = [[--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --glob='!Cargo.lock' -e]],
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
    vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = 'Grep' })
    vim.keymap.set('n', '<leader>sr', fzf.resume, { desc = 'Resume' })
    vim.keymap.set('n', '<leader>/', fzf.lgrep_curbuf, { desc = 'Search current buffer' })
    vim.keymap.set('n', '<leader>sb', fzf.buffers, { desc = 'Buffers' })
    vim.keymap.set('n', '<leader>sD', fzf.diagnostics_document, { desc = 'Diagnostics' })
    vim.keymap.set('n', '<leader>sk', fzf.keymaps, { desc = 'Keymaps' })
    vim.keymap.set('n', '<leader>sh', fzf.helptags, { desc = 'Help' })

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
