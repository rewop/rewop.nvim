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
  keys = {
    { '<leader>rr', '<cmd>Review<cr>', desc = 'Review working tree' },
    { '<leader>rc', '<cmd>Review commits<cr>', desc = 'Review commits' },
    { '<leader>rb', '<cmd>Review branch<cr>', desc = 'Review branch' },
    { '<leader>rv', function() require('rewop.extensions.codediff-reviewed').toggle() end, desc = 'Toggle file reviewed (codediff)' },
    { '<leader>rV', function() require('rewop.extensions.codediff-reviewed').clear() end, desc = 'Clear reviewed marks (codediff)' },
    { '<leader>rl', '<cmd>Review list<cr>', desc = 'Review list comments' },
    { '<leader>rp', '<cmd>Review preview<cr>', desc = 'Review preview export' },
    { '<leader>rs', '<cmd>Review sidekick<cr>', desc = 'Review send comments to sidekick' },
  },
}
