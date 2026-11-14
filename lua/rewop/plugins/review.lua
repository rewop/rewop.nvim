return {
  'georgeguimaraes/review.nvim',
  version = '*',
  dependencies = {
    {
      'esmuellert/codediff.nvim',
      opts = function()
        local reviewed = require 'rewop.extensions.codediff-reviewed'
        return {
          explorer = {
            view_mode = 'tree',
            formatters = { file = reviewed.file_formatter(reviewed.current_root) },
          },
          history = { view_mode = 'tree' },
        }
      end,
    },
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Review',
  opts = {},
  config = function(_, opts)
    local review = require 'review'
    review.setup(opts)
    require('rewop.extensions.review-tabs').setup()
    -- WORKAROUND (review.nvim 1.10.1): close() runs a bare `tabclose` before
    -- restoring buffer options/clearing comments. When the review is the only
    -- tab that throws E784 and aborts the rest, leaving buffers 'nomodifiable'
    -- (E21 later). Open a spare tab behind it so tabclose always succeeds.
    local close = review.close
    review.close = function(...)
      if #vim.api.nvim_list_tabpages() == 1 then
        vim.cmd 'tabnew'
        vim.cmd 'tabprevious'
      end
      return close(...)
    end
  end,
  keys = {
    {
      '<leader>rr',
      function()
        require('rewop.extensions.review-tabs').goto_or_open()
      end,
      desc = 'Review: go to open review / start',
    },
    { '<leader>rq', '<cmd>Review close<cr>', desc = 'Review close (export comments)' },
    { '<leader>rc', '<cmd>Review commits<cr>', desc = 'Review commits' },
    { '<leader>rb', '<cmd>Review branch<cr>', desc = 'Review branch' },
    {
      '<leader>rv',
      function()
        require('rewop.extensions.codediff-reviewed').toggle()
      end,
      desc = 'Toggle file reviewed (codediff)',
    },
    {
      '<leader>rV',
      function()
        require('rewop.extensions.codediff-reviewed').clear()
      end,
      desc = 'Clear reviewed marks (codediff)',
    },
    { '<leader>rl', '<cmd>Review list<cr>', desc = 'Review list comments' },
    { '<leader>rp', '<cmd>Review preview<cr>', desc = 'Review preview export' },
    { '<leader>rs', '<cmd>Review sidekick<cr>', desc = 'Review send comments to sidekick' },
  },
}
