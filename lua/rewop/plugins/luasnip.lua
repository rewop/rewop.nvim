return {
  '3MON4D3/LuaSnip',
  dependencies = {
    'rafamadriz/friendly-snippets',
  },
  event = 'InsertEnter',
  config = function()
    local ls = require 'luasnip'
    local ks = vim.keymap.set

    -- load snippets from friendly snippets
    require('luasnip.loaders.from_vscode').lazy_load()

    -- set up keybindings
    ks({ 'i' }, '<C-K>', function()
      ls.expand()
    end, { silent = true })
    ks({ 'i', 's' }, '<C-L>', function()
      ls.jump(1)
    end, { silent = true })
    ks({ 'i', 's' }, '<C-H>', function()
      ls.jump(-1)
    end, { silent = true })

    ks({ 'i', 's' }, '<C-E>', function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, { silent = true })

    -- setup snippets for astro
    ls.filetype_extend('astro', { 'html', 'javascript', 'typescript' })
  end,
}
