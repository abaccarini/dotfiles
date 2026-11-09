-- Hard-wrap edits to match the file being edited.  The width (and whether sentences end with two
-- spaces) is inferred from the file's own wrapped lines.  On leaving insert mode, if the line
-- just edited is too long, or short enough to take the next line's first word, the text is
-- reflowed with `gw` from that line to the end of its block of prose.  Lines above are never
-- touched, so a diff shows only the lines that had to move.
--
-- Auto-reflow is on whenever 'textwidth' > 0: `:setlocal tw=0` turns it off, and `:setlocal tw=N`
-- turns it on for a file with no width to infer.  `u` right after leaving insert undoes the reflow
-- only.  For edits made in normal mode, `:TexReflow` reflows by hand.

local bufnr = vim.api.nvim_get_current_buf()

-- Commands that own their line: a reflow never joins them with prose (\ab and \claude are notes).
local own_line = {
  begin = true,
  ['end'] = true,
  item = true,
  label = true,
  part = true,
  chapter = true,
  section = true,
  subsection = true,
  subsubsection = true,
  paragraph = true,
  subparagraph = true,
  ab = true,
  claude = true,
  centering = true,
  includegraphics = true,
  input = true,
  include = true,
}

-- Environments whose lines are not prose (math environments are caught by VimTeX's syntax).
local skip_env = { 'tabular', 'array', 'verbatim', 'Verbatim', 'lstlisting', 'minted', 'tikzpicture', 'algorithm' }

local function command(s)
  return s:match '^%s*\\(%a+)'
end

local function has_comment(s)
  return s:find '^%s*%%' ~= nil or s:find '[^\\]%%' ~= nil
end

-- Whether `s` is a line of prose that a reflow may join with its neighbours.
local function prose(s)
  return not (s:match '^%s*$' or s:match '^%s*\\[%[%]]' or s:match '^%s*%$%$' or own_line[command(s)] or has_comment(s))
end

local function ends_row(s)
  return s:match '\\\\%s*$' ~= nil or s:match '\\\\%[[^%]]*%]%s*$' ~= nil
end

-- The width the file is wrapped at: the 90th percentile of lines that wrap into the next one, so
-- that overlong lines not yet reflowed are ignored.  A file with few such lines, or ragged ones
-- (unwrapped, or one sentence per line), is not treated as wrapped.
local function infer_width(lines)
  local widths = {}
  for i = 1, #lines - 1 do
    local cur = lines[i]:gsub('%s+$', '')
    if prose(cur) and prose(lines[i + 1]) and not ends_row(cur) then
      widths[#widths + 1] = vim.api.nvim_strwidth(cur)
    end
  end
  if #widths < 10 then
    return 0
  end
  table.sort(widths)
  local tw = widths[math.ceil(#widths * 0.9)]
  local tight = #vim.tbl_filter(function(w)
    return w > tw - 20 and w <= tw
  end, widths)
  return tight >= 0.6 * #widths and tw or 0
end

local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
local width = infer_width(lines)
if width > 0 then
  vim.bo[bufnr].textwidth = width
end
-- No wrapping while typing: it would also break lines the reflow leaves alone (math, tables,
-- standalone \ab comments).
vim.opt_local.formatoptions:remove 't'
local text = table.concat(lines, '\n')
local _, two = text:gsub('[.?!]  %S', '')
local _, one = text:gsub('%l[.?!] %u', '')
vim.b[bufnr].tex_joinspaces = two > one

-- 'joinspaces' is global, so it follows the current buffer; it also makes `gq`, `gw` and `J`
-- follow the file's sentence spacing.
local group = vim.api.nvim_create_augroup('tex_autowrap_' .. bufnr, { clear = true })
local saved_joinspaces = vim.o.joinspaces
local function enter()
  saved_joinspaces = vim.o.joinspaces
  vim.o.joinspaces = vim.b[bufnr].tex_joinspaces
end
vim.api.nvim_create_autocmd('BufEnter', { group = group, buffer = bufnr, callback = enter })
vim.api.nvim_create_autocmd('BufLeave', {
  group = group,
  buffer = bufnr,
  callback = function()
    vim.o.joinspaces = saved_joinspaces
  end,
})
if vim.api.nvim_get_current_buf() == bufnr then
  enter()
end

-- The environments around the cursor, innermost first, as vimtex#env#get_all() gives them.  That
-- function never returns when an environment opens at line 1, column 1, as \begin{abstract} does
-- in the abstract: it steps back from each \begin, and there it steps back onto the same one.
local function environments()
  local view = vim.fn.winsaveview()
  local envs = {}
  while true do
    local env = vim.fn['vimtex#env#get_inner']()
    if vim.tbl_isempty(env) then
      break
    end
    envs[#envs + 1] = env
    if env.open.lnum == 1 and env.open.cnum <= 1 then
      break
    end
    vim.fn['vimtex#pos#set_cursor'](vim.fn['vimtex#pos#prev'](env.open))
  end
  vim.fn.winrestview(view)
  return envs
end

local function in_skipped_region(lnum, line)
  local ok, in_math = pcall(vim.fn['vimtex#syntax#in_mathzone'], lnum, 1)
  if ok and in_math == 1 and vim.fn['vimtex#syntax#in_mathzone'](lnum, #line) == 1 then
    return true
  end
  local ok_env, envs = pcall(environments)
  for _, env in ipairs(ok_env and envs or {}) do
    for _, name in ipairs(skip_env) do
      if env.name:find('^' .. name) then
        return true
      end
    end
  end
  return false
end

local function reflow(separate_undo)
  local tw = vim.bo[bufnr].textwidth
  local lnum, last = vim.fn.line '.', vim.fn.line '$'
  local line = vim.fn.getline(lnum)
  if tw == 0 or not (prose(line) or command(line) == 'item') or in_skipped_region(lnum, line) then
    return
  end

  local next_line = lnum < last and vim.fn.getline(lnum + 1) or ''
  local len = vim.api.nvim_strwidth((line:gsub('%s+$', '')))
  local takes_next = prose(next_line)
    and not ends_row(line)
    and len + 1 + vim.api.nvim_strwidth(next_line:match '^%s*(%S+)') <= tw
  if len <= tw and not takes_next then
    return
  end

  local stop = lnum
  while stop < last and not ends_row(vim.fn.getline(stop)) and prose(vim.fn.getline(stop + 1)) do
    stop = stop + 1
  end
  -- A separate undo step lets `u` take back the reflow but not the edit.  `gw` keeps the cursor on
  -- the same text; a count before `gww` would apply to a `w` motion.
  if separate_undo then
    vim.cmd 'let &g:undolevels = &g:undolevels'
  end
  -- A line broken off keeps the indent of the one it is broken from ('autoindent'), rather than
  -- taking the one 'indentexpr' gives: GetTeXIndent() indents the body of every environment,
  -- which these files leave unindented in abstract, proof and the theorem-like ones.
  local indentexpr = vim.bo[bufnr].indentexpr
  vim.bo[bufnr].indentexpr = ''
  pcall(vim.cmd, 'silent keepjumps normal! gw' .. stop .. 'G')
  vim.bo[bufnr].indentexpr = indentexpr
end

-- Also used after accepting or rejecting suggested edits (after/ftplugin/tex_changes.lua).
vim.api.nvim_buf_create_user_command(bufnr, 'TexReflow', function()
  reflow(false)
end, { desc = 'Reflow from the cursor line to the end of its block, if it is not filled' })

local tick = vim.b[bufnr].changedtick
vim.api.nvim_create_autocmd('InsertEnter', {
  group = group,
  buffer = bufnr,
  callback = function()
    tick = vim.b[bufnr].changedtick
  end,
})
-- ModeChanged rather than InsertLeave: it also fires on <C-c>, and the new mode tells a real exit
-- apart from a one-off <C-o> command.
vim.api.nvim_create_autocmd('ModeChanged', {
  group = group,
  buffer = bufnr,
  callback = function()
    if vim.v.event.old_mode:match '^[iR]' and vim.v.event.new_mode == 'n' and vim.b[bufnr].changedtick ~= tick then
      reflow(true)
    end
  end,
})
