return {
  'JoosepAlviste/nvim-ts-context-commentstring',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('ts_context_commentstring').setup {
      -- required for integration with commen.nvim
      -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring/wiki/Integrations#commentnvim
      enable_autocmd = false,
    }
  end,
}
