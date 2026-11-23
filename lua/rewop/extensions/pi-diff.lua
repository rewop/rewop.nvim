-- :PiDiff — review what the pi agent changed, in codediff + review.nvim.
--
-- The pi extension pi-snapshots.ts (~/.dotfiles/pi/...) snapshots the working tree before each
-- prompt into refs/pi/<worktree-id>/<session>/{prompt,base}. :PiDiff takes a fresh snapshot of
-- "now" with the same `pi-snapshot` script and opens `:CodeDiff <snapshot> <now>`. Commit-vs-commit
-- on purpose: `:CodeDiff <rev>` (rev vs working tree) misreports files that were untracked when the
-- snapshot was taken (shows them as deleted + untracked).
--
--   :PiDiff [prompt]  newest prompt snapshot in this worktree (what the last prompt changed)
--   :PiDiff base      newest session start (everything the session changed)
--   :PiDiff pick      choose any session/prompt snapshot
--   :PiDiff <ref>     explicit ref (what pi's `/diff` passes)
--
-- Both panes are read-only commit views (review.nvim is read-only by default anyway); open the real
-- file from the diff to edit. Review comments export to the clipboard as usual (q / C).
local M = {}

local function snapshot_bin()
  local bin = vim.fn.exepath 'pi-snapshot'
  return bin ~= '' and bin or vim.fn.expand '~/.dotfiles/zsh/bin/pi-snapshot'
end

---@return string|nil stdout, string stderr
local function run(cmd, cwd)
  local r = vim.system(cmd, { cwd = cwd, text = true }):wait()
  if r.code ~= 0 then
    return nil, vim.trim(r.stderr or '')
  end
  return vim.trim(r.stdout), ''
end

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = 'PiDiff' })
end

---@return { ref: string, kind: string, session: string, age: string, subject: string }[]
local function snapshots(cwd)
  local wt = run({ snapshot_bin(), '--wt-id' }, cwd)
  if not wt then
    return {}
  end
  local out = run({
    'git', 'for-each-ref', '--sort=-committerdate',
    '--format=%(refname)%09%(committerdate:relative)%09%(contents:subject)',
    'refs/pi/' .. wt .. '/',
  }, cwd) or ''
  local list = {}
  for line in out:gmatch '[^\n]+' do
    local ref, age, subject = line:match '^([^\t]+)\t([^\t]*)\t?(.*)$'
    local session, kind = ref:match '/([^/]+)/([^/]+)$'
    table.insert(list, { ref = ref, kind = kind, session = session, age = age, subject = subject })
  end
  return list
end

local function open(cwd, ref)
  local now, err = run({ snapshot_bin(), 'PiDiff now' }, cwd)
  if not now then
    return notify('snapshot failed: ' .. err, vim.log.levels.ERROR)
  end
  if vim.system({ 'git', 'diff', '--quiet', ref, now }, { cwd = cwd }):wait().code == 0 then
    return notify('No changes since ' .. ref)
  end
  -- Loads review.nvim (lazy) so its hooks attach to the CodeDiff tab. Its store is only loaded by
  -- its own :Review entry points; without this the first new comment would overwrite saved ones.
  require 'review'
  require('review.store').load()
  vim.cmd { cmd = 'CodeDiff', args = { ref, now } }
end

function M.diff(arg)
  local cwd = vim.fn.getcwd()
  if not run({ 'git', 'rev-parse', '--show-toplevel' }, cwd) then
    return notify('Not in a git worktree', vim.log.levels.WARN)
  end
  arg = (arg and arg ~= '') and arg or 'prompt'

  if arg:match '^refs/' then
    return open(cwd, arg)
  end

  local list = snapshots(cwd)
  if #list == 0 then
    return notify 'No pi snapshots in this worktree yet'
  end

  if arg == 'pick' then
    vim.ui.select(list, {
      prompt = 'pi snapshot',
      format_item = function(s)
        return string.format('%-6s %s  %-16s %s', s.kind, s.session, s.age, s.subject)
      end,
    }, function(choice)
      if choice then
        open(cwd, choice.ref)
      end
    end)
    return
  end

  for _, s in ipairs(list) do
    if s.kind == arg then
      return open(cwd, s.ref)
    end
  end
  notify('No "' .. arg .. '" snapshot found', vim.log.levels.WARN)
end

function M.setup()
  vim.api.nvim_create_user_command('PiDiff', function(o)
    M.diff(o.args)
  end, {
    nargs = '?',
    desc = 'Review what pi changed (codediff + review.nvim)',
    complete = function()
      return { 'prompt', 'base', 'pick' }
    end,
  })
end

return M
