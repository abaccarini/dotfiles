return {
  'lervag/vimtex',
  dependencies = { 'Mofiqul/dracula.nvim' },
  lazy = false, -- we don't want to lazy load VimTeX
  -- enabled = false,
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- vim.o.conceallevel = 2
    -- vim.g.tex_conceal = ''
    -- vim.g.vimtex_quickfix_method = vim.fn.executable 'pplatex' == 1 and 'pplatex' or 'latexlog'
    -- vim.g.vimtex_quickfix_method = 'pplatex'

    if vim.loop.os_uname().sysname ~= 'Darwin' then
      vim.g.vimtex_quickfix_method = 'pplatex'
    end
    -- vim.g.vimtex_compiler_latexmk = {
    --   continuous = false,
    -- }

    -- vim.cmd [[
    --   let g:vimtex_compiler_latexmk = {
    --               \ 'backend' : 'jobs',
    --               \ 'background' : 1,
    --               \ 'build_dir' : '',
    --               \ 'callback' : 1,
    --               \ 'continuous' : 1,
    --               \ 'executable' : 'latexmk',
    --               \ 'options' : [
    --               \   '-pdf',
    --               \   '-bibtex',
    --               \   '-verbose',
    --               \   '-file-line-error',
    --               \   '-synctex=1',
    --               \   '-interaction=nonstopmode',
    --               \ ],
    --               \}
    --   ]]

    vim.cmd [[
        let g:vimtex_quickfix_ignore_filters = [
          \ '\(Ov\|Und\)erfull',
          \'Missing character',
          \'Missing "publisher"',
          \'Missing "author"',
          \'Missing "address"',
          \'(LaTeX Font)',
          \'Package caption Warning',
          \'(Package caption)',
          \'(Package fancyhdr)',
          \'Token not allowed in a PDF string',
          \'(Package hyperref)  removing',
          \'Float too large',
          \'Class acmart Warning:',
          \'Package fancyhdr Warning:',
          \'No file OMScmtt.fd.',
          \'balance=false',
          \'A possible image without description',
          \'(Class acmart)',
          \'No file TUzi4.fd.'
          \]
      ]]

    vim.cmd [[
      let g:vimtex_complete_bib = {
      \ 'abbr_fmt' : '[@type] @author_short (@year)',
      \ 'menu_fmt' : '@title',
      \}
      ]]

    -- vim.cmd [[ let g:vimtex_mappings_disable = {  'i': '\]\]', } ]]
    -- vim.api.nvim_set_keymap('i', ']', ']', { noremap = true, silent = true })
    -- vim.api.nvim_set_keymap('i', ']]', "<plug>(disable-]]) <plug>(vimtex-delim-close)", { noremap = true, silent = true });

    -- vim.cmd [[
    -- imap <plug>(disable-]]) <plug>(vimtex-delim-close)
    -- -- let g:vimtex_mappings_disable =
    -- --   \ 'i': ['\]\]']
    -- --   \}
    --   ]]
    -- vim.g.vimtex_mappings_disable = { 'i': ['\]\]'] }

    vim.api.nvim_set_keymap('i', '<c-|>', '<plug>(vimtex-delim-close)', { noremap = true }) -- set this to something I can't type, essentially just remove it
    -- vim.cmd [[
    -- let g:vimtex_mappings_disable = {
    --     " \ 'n': ['tse', 'tsd'],
    --     " \ 'x': ['tsd'],
    --     \ 'i': [' ]],
    --     \}
    -- ]]

    vim.g.vimtex_quickfix_enabled = 1
    vim.g.vimtex_matchparen_enabled = 0
    vim.g.vimtex_mwatchparen_enabled = 0
    -- vim.g.vimtex_format_enabled = 1

    vim.g.vimtex_syntax_nospell_comments = 1

    if vim.loop.os_uname().sysname == 'Darwin' then
      -- vim.g.vimtex_view_method = 'skim'
      vim.g.vimtex_view_method = 'sioyek'
      vim.g.vimtex_view_sioyek_exe = '/Applications/sioyek.app/Contents/MacOS/sioyek'
      -- vim.g.vimtex_view_skim_sync = 1
      -- vim.g.vimtex_view_skim_activate = 1
    else
      vim.g.vimtex_view_method = 'zathura'
    end

    local colors = require('dracula').colors()

    vim.cmd.hi('texCmdMath  guifg=' .. colors['red'])
    vim.cmd.hi('Conceal  guifg=' .. colors['bright_cyan'])
    vim.cmd.hi('texMathDelim  guifg=' .. colors['pink'])
    vim.cmd.hi('texMathDelimZoneTI  guifg=' .. colors['yellow'])
    -- vim.cmd.hi('texMathZone  guifg=' .. colors['cyan'])
    vim.cmd.hi('texRefArg gui=italic  guifg=' .. colors['orange'])
    vim.cmd.hi('texCmdPart  guifg=' .. colors['bright_cyan'])
    vim.cmd.hi('texPartArgTitle  gui=bold      guifg=' .. colors['bright_yellow'])
    vim.cmd.hi('texCmd  guifg=' .. colors['cyan'])
    vim.cmd.hi('texCmdRef  guifg=' .. colors['pink'])
    vim.cmd.hi('texCmdPackage  guifg=' .. colors['pink'])
    vim.cmd.hi('texFilesArg gui=italic  guifg=' .. colors['bright_cyan'])
    vim.cmd.hi('texFilesOpt gui=italic  guifg=' .. colors['orange'])
    vim.cmd.hi('texEnvArgName gui=italic guifg=' .. colors['orange'])
    vim.cmd.hi('texMathEnvArgName gui=italic guifg=' .. colors['orange'])
    vim.cmd.hi('texDefArgName  gui=italic guifg=' .. colors['orange'])
    vim.cmd.hi('texMathZone  gui=italic guifg=' .. colors['bright_cyan'])
    vim.cmd.hi('texCmdNew   guifg=' .. colors['pink'])
    vim.cmd.hi('texArgNew   guifg=' .. colors['bright_cyan'])
    -- vim.cmd.hi('texDefParm   guifg=' .. colors['bright_cyan'])
    -- hi! def link Conceal guifg=color ctermfg=color
    -- vim.g.vimtex_view_general_viewer = 'zathura'
    -- vim.g.vimtex_view_zathura_options = '-reuse-instance'
  end,
}
