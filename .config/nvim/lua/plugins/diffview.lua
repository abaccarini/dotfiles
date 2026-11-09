-- Review a GitHub PR as its "Files changed" tab shows it: the PR head against its merge
-- base with the base branch (`base...head`), or its commits one at a time. Without a
-- number, the PR is the current branch's.

local remote = 'origin'

-- Runs `cmd` without blocking the UI; call from a coroutine. Returns stdout, or nil and
-- stderr on failure.
local function run(cmd)
  local co = coroutine.running()
  vim.system(cmd, { text = true }, function(res)
    vim.schedule(function()
      coroutine.resume(co, res)
    end)
  end)
  local res = coroutine.yield()
  if res.code ~= 0 then
    return nil, vim.trim(res.stderr)
  end
  return vim.trim(res.stdout)
end

-- Fetches PR `number` and its base branch, and returns the revs to compare. The head is
-- `HEAD` when it's checked out here, so diffview can show the local files (with LSP).
local function pr_revs(number)
  local cmd = { 'gh', 'pr', 'view', '--json', 'number,baseRefName,headRefOid' }
  if number then
    table.insert(cmd, number)
  end
  local out, err = run(cmd)
  if not out then
    return nil, err
  end
  local pr = vim.json.decode(out)

  vim.notify(('Fetching PR #%d…'):format(pr.number))
  out, err = run { 'git', 'fetch', remote, pr.baseRefName, ('pull/%d/head'):format(pr.number) }
  if not out then
    return nil, err
  end

  local revs = { number = pr.number, base = remote .. '/' .. pr.baseRefName, head = pr.headRefOid }
  if run { 'git', 'rev-parse', 'HEAD' } == pr.headRefOid then
    revs.head = 'HEAD'
    revs.dirty = run { 'git', 'status', '--porcelain', '--untracked-files=no' } ~= ''
  end
  return revs
end

local function with_pr(number, open)
  coroutine.wrap(function()
    local revs, err = pr_revs(number)
    if not revs then
      return vim.notify('PR review: ' .. err, vim.log.levels.ERROR)
    end
    open(revs)
  end)()
end

local function open_diff(revs)
  if revs.head == 'HEAD' then
    if revs.dirty then
      vim.notify(('PR #%d: uncommitted changes show in the diff too'):format(revs.number), vim.log.levels.WARN)
    end
    vim.cmd(('DiffviewOpen %s...HEAD --imply-local'):format(revs.base))
  else
    vim.notify(('PR #%d: not checked out here, showing GitHub\'s head %s read-only'):format(revs.number, revs.head:sub(1, 8)))
    vim.cmd(('DiffviewOpen %s...%s'):format(revs.base, revs.head))
  end
end

local function open_commits(revs)
  vim.cmd(('DiffviewFileHistory --range=%s..%s'):format(revs.base, revs.head))
end

-- Closes the current diffview, or opens the current branch's PR with `open`.
local function toggle(open)
  return function()
    if require('diffview.lib').get_current_view() then
      vim.cmd.DiffviewClose()
    else
      with_pr(nil, open)
    end
  end
end

return {
  'sindrets/diffview.nvim',
  config = function()
    require('diffview').setup()

    vim.api.nvim_create_user_command('DiffviewPR', function(cmd)
      with_pr(cmd.fargs[1], open_diff)
    end, { nargs = '?', desc = 'Diff a GitHub PR against its merge base' })
    vim.api.nvim_create_user_command('DiffviewPRCommits', function(cmd)
      with_pr(cmd.fargs[1], open_commits)
    end, { nargs = '?', desc = 'Step through a GitHub PR commit by commit' })

    vim.keymap.set('n', '<leader>gv', toggle(open_diff), { desc = 'PR diff' })
    vim.keymap.set('n', '<leader>gV', toggle(open_commits), { desc = 'PR commits' })
  end,
}
