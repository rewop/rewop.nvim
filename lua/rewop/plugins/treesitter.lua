-- Highlight, edit, and navigate code
local ensure_installed = {
  'c',
  'cpp',
  'go',
  'lua',
  'python',
  'tsx',
  'javascript',
  'typescript',
  'vimdoc',
  'vim',
  'bash',
  'astro',
  'css',
  'proto',
  'http',
  'prisma',
  'c_sharp',
  'markdown',
  'markdown_inline',
}

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
  },
  config = function()
    require('nvim-treesitter').install(ensure_installed)

    -- Highlighting and indentation are provided by Neovim itself; nvim-treesitter
    -- only ships the parsers/queries. See :h treesitter-highlight
    vim.api.nvim_create_autocmd('FileType', {
      callback = function()
        pcall(vim.treesitter.start)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    -- Text objects: select
    local ts_select = require 'nvim-treesitter-textobjects.select'
    require('nvim-treesitter-textobjects').setup {
      select = {
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      },
      move = {
        set_jumps = true, -- whether to set jumps in the jumplist
      },
    }

    local select_keymaps = {
      ['aa'] = '@parameter.outer',
      ['ia'] = '@parameter.inner',
      ['af'] = '@function.outer',
      ['if'] = '@function.inner',
      ['ac'] = '@class.outer',
      ['ic'] = '@class.inner',
    }
    for lhs, query_string in pairs(select_keymaps) do
      vim.keymap.set({ 'x', 'o' }, lhs, function()
        ts_select.select_textobject(query_string, 'textobjects')
      end)
    end

    -- Text objects: move
    local ts_move = require 'nvim-treesitter-textobjects.move'
    local move_keymaps = {
      goto_next_start = { [']m'] = '@function.outer', [']]'] = '@class.outer' },
      goto_next_end = { [']M'] = '@function.outer', [']['] = '@class.outer' },
      goto_previous_start = { ['[m'] = '@function.outer', ['[['] = '@class.outer' },
      goto_previous_end = { ['[M'] = '@function.outer', ['[]'] = '@class.outer' },
    }
    for fn_name, keymaps in pairs(move_keymaps) do
      for lhs, query_string in pairs(keymaps) do
        vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
          ts_move[fn_name](query_string, 'textobjects')
        end)
      end
    end

    -- Text objects: swap
    local ts_swap = require 'nvim-treesitter-textobjects.swap'
    vim.keymap.set('n', ']a', function()
      ts_swap.swap_next '@parameter.inner'
    end)
    vim.keymap.set('n', '[a', function()
      ts_swap.swap_previous '@parameter.inner'
    end)

    -- set key maps
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
    vim.keymap.set('n', '<leader>ds', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
    vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
  end,
}
