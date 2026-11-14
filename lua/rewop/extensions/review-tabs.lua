-- WORKAROUND (review.nvim 1.10.1): codediff's `gf` (open_in_prev_tab) shows the
-- *same* working-tree buffer in another tab. codediff suspends its own keymaps
-- on TabLeave, but review.nvim does not, so that buffer keeps review's
-- 'nomodifiable'/'readonly' and its buffer-local keys (`q` -> review.close(),
-- which tabcloses whatever tab you are in; i/d/e/F/R/]f...).
-- Mirror codediff: strip review state when leaving the review tab, reapply it
-- when coming back.
-- Caveats: relies on review internals (hooks.get_current_tabpage,
-- hooks.restore_buffer_options, hooks.on_file_changed, keymaps.setup_keymaps).
local M = {}

local function review_tab()
  local ok, hooks = pcall(require, 'review.hooks')
  return ok and hooks.get_current_tabpage() or nil, hooks
end

--- Jump to the open review tab, or start a new review if there is none.
function M.goto_or_open()
  local tab = package.loaded['review.hooks'] and review_tab()
  if tab and vim.api.nvim_tabpage_is_valid(tab) then
    vim.api.nvim_set_current_tabpage(tab)
  else
    vim.cmd 'Review'
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup('ReviewTabs', { clear = true })

  vim.api.nvim_create_autocmd('TabLeave', {
    group = group,
    callback = function()
      local tab, hooks = review_tab()
      if not tab or tab ~= vim.api.nvim_get_current_tabpage() then
        return
      end
      hooks.restore_buffer_options()
      require('review.keymaps').clear_keymaps()
    end,
  })

  vim.api.nvim_create_autocmd('TabEnter', {
    group = group,
    callback = function()
      local tab, hooks = review_tab()
      if not tab or tab ~= vim.api.nvim_get_current_tabpage() then
        return
      end
      -- reapplies readonly (if still enabled via `R`), filetype and marks
      hooks.on_file_changed(tab)
      require('review.keymaps').setup_keymaps(tab)
    end,
  })
end

return M
