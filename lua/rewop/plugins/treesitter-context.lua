-- Pin the enclosing function/class header at the top of the window, so hunks
-- inside a folded method (e.g. codediff compact mode) show which method they
-- belong to. Config mirrors LazyVim's ui.treesitter-context extra.
return {
  'nvim-treesitter/nvim-treesitter-context',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    mode = 'cursor', -- context of the cursor line, not the window's top line
    max_lines = 3,
    multiwindow = true, -- show context in both diff panes, not just the focused one
  },
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
