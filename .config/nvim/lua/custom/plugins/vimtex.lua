return {
  'lervag/vimtex',
  dependencies = { 'Mofiqul/dracula.nvim' },
  lazy = false, -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    local my_augroup = vim.api.nvim_create_augroup('mygroup', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'tex' },
      command = 'setlocal spell spelllang=en_us | set spellcapcheck= | syntax spell toplevel ',
      group = my_augroup,
    })
    vim.o.conceallevel = 2
    vim.g.tex_conceal = ''
    vim.g.tex_fast = 'bMpr'

    -- vim.g.vimtex_compiler_latexmk = {
    --   continuous = false,
    -- }

    vim.cmd [[
        let g:vimtex_quickfix_ignore_filters = [
        \'Underfull',
          \'Overfull',
          \'Missing character',
          \]
        ]]
    vim.cmd [[
      let g:vimtex_complete_bib = {
      \ 'abbr_fmt' : '[@type] @author_short (@year)',
      \ 'menu_fmt' : '@title',
      \}

      ]]

    -- vim.g.vimtex_quickfix_enabled = 0
    vim.g.vimtex_match_paren_enabled = 0
    -- vim.g.vimtex_format_enabled = 1

    vim.g.vimtex_syntax_nospell_comments = 1

    if vim.loop.os_uname().sysname == 'Darwin' then
      vim.g.vimtex_view_method = 'skim'
      vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_skim_activate = 1
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
