return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  cmd = 'Neotree',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    {
      's1n7ax/nvim-window-picker',
      version = '2.*',
      config = function()
        require('window-picker').setup {
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            -- filter using buffer options
            bo = {
              -- if the file type is one of following, the window will be ignored
              filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
              -- if the buffer type is one of following, the window will be ignored
              buftype = { 'terminal', 'quickfix' },
            },
          },
        }
      end,
    },
  },
  init = function()
    -- disable netrw
    vim.g.loaded_netrwPlugin = 1
    vim.g.loaded_netrw = 1

    -- [[Keymaps]]
    local km = vim.keymap
    km.set('n', '<leader>et', '<cmd>Neotree toggle last<CR>', { desc = 'Toggle neotree explorer' })
    km.set('n', '<leader>ec', '<cmd>Neotree close<CR>', { desc = 'Close neotree explorer' })
    km.set('n', '<leader>ee', '<cmd>Neotree focus last<CR>', { desc = 'Focus neotree explorer' })
    km.set('n', '<leader>ef', '<cmd>Neotree focus filesystem<CR>', { desc = 'Show neotree file explorer' })
    km.set('n', '<leader>eg', '<cmd>Neotree focus git_status<CR>', { desc = 'Show neotree git status explorer' })
    km.set('n', '<leader>eb', '<cmd>Neotree focus buffers<CR>', { desc = 'Show neotree buffer explorer' })
  end,

  config = function()
    local neotree = require 'neo-tree'

    neotree.setup {
      window = {
        position = 'right',
        mappings = {
          -- go to the parent
          ['P'] = function(state)
            local node = state.tree:get_node()
            require('neo-tree.ui.renderer').focus_node(state, node:get_parent_id())
          end,
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
      },
      buffers = {
        follow_current_file = {
          enabled = true,
        },
      },
    }
  end,
}
