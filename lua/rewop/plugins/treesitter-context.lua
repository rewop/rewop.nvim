-- Pin the enclosing function/class header at the top of the window: in normal
-- files once you scroll past the signature, and in diffs so hunks inside a
-- folded method (e.g. codediff compact mode) show which method they belong to.
-- Highlights live in plugins/colorscheme.lua.
return {
  'nvim-treesitter/nvim-treesitter-context',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    mode = 'topline', -- switched per window below
    max_lines = 3,
    multiline_threshold = 1, -- only the first line of multi-line signatures
    separator = '─', -- thin rule under the header (TreesitterContextSeparator)
    multiwindow = true, -- show context in both diff panes, not just the focused one
  },
  config = function(_, opts)
    local tsc = require 'treesitter-context'
    tsc.setup(opts)

    -- `mode` is global, so pick it from the focused window: diffs follow the
    -- cursor (the hunk you're on), normal files follow the top visible line
    -- (scrolling alone is enough to show the method you're in).
    local function sync_mode()
      local mode = vim.wo.diff and 'cursor' or 'topline'
      local config = require 'treesitter-context.config'
      if config.mode ~= mode then
        config.update { mode = mode }
      end
    end
    vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter' }, {
      group = vim.api.nvim_create_augroup('rewop_ts_context_mode', {}),
      callback = sync_mode,
    })
    vim.api.nvim_create_autocmd('OptionSet', {
      group = 'rewop_ts_context_mode',
      pattern = 'diff',
      callback = sync_mode,
    })
    sync_mode()
  end,
  keys = {
    {
      '<leader>ut',
      function()
        require('treesitter-context').toggle()
      end,
      desc = 'Toggle treesitter context',
    },
  },
}
