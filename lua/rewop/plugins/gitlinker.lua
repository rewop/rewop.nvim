return {
  'ruifm/gitlinker.nvim',
  dependecies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local gl = require 'gitlinker'
    local gl_actions = require 'gitlinker.actions'
    gl.setup()

    local vk = vim.keymap.set

    vk('n', '<leader>gP', function()
      gl.get_buf_range_url('n', { action_callback = gl_actions.open_in_browser })
    end, { silent = true, desc = 'Open permalink in browser' })
    vk('v', '<leader>gP', function()
      gl.get_buf_range_url('v', { action_callback = gl_actions.open_in_browser })
    end, { silent = true, desc = 'Open permalink in browser' })
  end,
}
