return {
  -- Autocompletion
  'saghen/blink.cmp',
  event = 'InsertEnter',
  version = '1.*',
  dependencies = {
    -- Snippet Engine (kept as a standalone plugin, see luasnip.lua)
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',
  },
  opts = {
    keymap = {
      preset = 'none',
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'fallback' },
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-space>'] = { 'show', 'fallback' },
      ['<C-e>'] = { 'cancel', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
    },
    snippets = { preset = 'luasnip' },
    completion = {
      documentation = { auto_show = true },
      menu = {
        border = 'rounded',
      },
    },
    signature = {
      window = {
        border = 'rounded',
      },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}
