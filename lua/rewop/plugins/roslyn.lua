return {
  'seblyng/roslyn.nvim',
  ft = 'cs',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
  },
  opts = function()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    return {
      broad_search = true,
      config = {
        capabilities = capabilities,
      },
    }
  end,
}
