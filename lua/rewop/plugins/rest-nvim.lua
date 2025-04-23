return {
  'rest-nvim/rest.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      print(vim.inspect(opts.ensure_installed))
      table.insert(opts.ensure_installed, 'http')
    end,
  },
}
