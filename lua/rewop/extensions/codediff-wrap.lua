-- WORKAROUND, to be evaluated: codediff.nvim forces `wrap` off in its diff
-- panes (on every render and on window/buffer enter) and has no option for it,
-- so a plain toggle does not stick. This keeps a per-tab flag and re-applies
-- wrap after codediff resets it.
-- Caveats:
--   * relies on codediff internals (lifecycle.get_session, session.*_win)
--   * side-by-side panes lose alignment on lines that wrap differently
local M = {}

local function panes()
  local lifecycle = package.loaded['codediff.ui.lifecycle']
  local session = lifecycle and lifecycle.get_session(vim.api.nvim_get_current_tabpage())
  if not session then
    return {}
  end
  local wins = {}
  for _, key in ipairs { 'original_win', 'modified_win' } do
    local win = session[key]
    if win and vim.api.nvim_win_is_valid(win) then
      table.insert(wins, win)
    end
  end
  return wins
end

local function apply()
  if not vim.t.codediff_wrap then
    return
  end
  for _, win in ipairs(panes()) do
    if not vim.wo[win].wrap then
      vim.wo[win].wrap = true
      vim.wo[win].linebreak = true
    end
  end
end

--- Toggle wrap for the codediff panes of the current tab.
--- @return boolean|nil new wrap state, nil if the current window is not a diff pane
function M.toggle()
  local wins = panes()
  if not vim.tbl_contains(wins, vim.api.nvim_get_current_win()) then
    return nil
  end
  local wrap = not vim.t.codediff_wrap
  vim.t.codediff_wrap = wrap
  for _, win in ipairs(wins) do
    vim.wo[win].wrap = wrap
    vim.wo[win].linebreak = wrap
  end
  return wrap
end

local group = vim.api.nvim_create_augroup('CodeDiffWrap', { clear = true })
local function reapply()
  if vim.t.codediff_wrap then
    -- scheduled so it runs after codediff's own handlers for the same events,
    -- deferred as well because some renders (e.g. layout toggle) finish later
    vim.schedule(apply)
    vim.defer_fn(apply, 100)
  end
end
-- codediff has no "rendered" event, so hook everything that surrounds a render
local events = {
  'BufWinEnter',
  'BufEnter',
  'WinEnter',
  'WinNew',
  'WinClosed',
  'FileType',
  'WinScrolled',
  'WinResized',
  'CursorMoved',
}
vim.api.nvim_create_autocmd(events, {
  callback = reapply,
  group = group,
})
vim.api.nvim_create_autocmd('User', {
  callback = reapply,
  group = group,
  pattern = { 'CodeDiffOpen', 'CodeDiffFileSelect', 'CodeDiffVirtualFileLoaded' },
})

return M
