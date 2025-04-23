return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'j-hui/fidget.nvim',
  },
  config = function()
    require('codecompanion').setup {
      strategies = {
        chat = {
          adapter = 'anthropic',
        },
        inline = {
          adapter = 'anthropic',
        },
      },
      adapters = {
        anthropic = function()
          return require('codecompanion.adapters').extend('anthropic', {
            env = {
              -- Get the API key from 1password
              api_key = 'cmd:op read op://Private/anwjyt2cf7fsh7gojdwzgx6bh4/password --no-newline',
            },
          })
        end,
      },
    }

    vim.keymap.set('n', '<leader>cc', '<cmd>CodeCompanionChat<cr>', { desc = 'Code Companion open Chat' })
    vim.keymap.set('n', '<leader>ci', '<cmd>CodeCompanion<cr>', { desc = 'Code Companion Inline' })
  end,
  init = function()
    require('rewop.extensions.codecompanion.fidget-spinner'):init()
  end,
}
