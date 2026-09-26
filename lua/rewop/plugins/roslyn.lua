return {
  'seblyng/roslyn.nvim',
  ft = 'cs',
  dependencies = {
    'saghen/blink.cmp',
  },
  opts = function()
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    return {
      broad_search = true,
      config = {
        capabilities = capabilities,
      },
    }
  end,
}
