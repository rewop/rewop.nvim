return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    harpoon.setup {}
    local ks = vim.keymap.set
    ks('n', '<leader>aa', function()
      harpoon:list():add()
    end, { desc = 'Add current file to harpoon' })
    ks('n', '<leader>ae', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Toggle Harpoon menu' })

    ks('n', '<leader>aj', function()
      harpoon:list():select(1)
    end, { desc = 'Select Harpoon item 1' })
    ks('n', '<leader>ak', function()
      harpoon:list():select(2)
    end, { desc = 'Select Harpoon item 2' })
    ks('n', '<leader>ah', function()
      harpoon:list():select(3)
    end, { desc = 'Select Harpoon item 3' })
    ks('n', '<leader>al', function()
      harpoon:list():select(4)
    end, { desc = 'Select Harpoon item 4' })

    ks('n', 'M-h', function()
      harpoon:list():select(1)
    end, { desc = 'Select Harpoon item 1' })
    ks('n', 'M-j', function()
      harpoon:list():select(2)
    end, { desc = 'Select Harpoon item 2' })
    ks('n', 'M-k', function()
      harpoon:list():select(3)
    end, { desc = 'Select Harpoon item 3' })
    ks('n', 'M-l', function()
      harpoon:list():select(4)
    end, { desc = 'Select Harpoon item 4' })

    -- Toggle previous & next buffers stored within Harpoon list
    ks('n', '<leader>ap', function()
      harpoon:list():prev()
    end, { desc = 'Select previous Harpoon item' })
    ks('n', '<leader>an', function()
      harpoon:list():next()
    end, { desc = 'Select next Harpoon item' })
  end,
}
