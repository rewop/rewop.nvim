-- TODO setup catppuccin colorscheme
return {
  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    name = 'onedark',
    priority = 1000,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        transparent_background = true,
        float = { transparent = true },
        integrations = {
          blink_cmp = true,
          dap = true,
          dap_ui = true,
          gitsigns = true,
          harpoon = true,
          indent_blankline = {
            enabled = true,
          },
          mason = true,
          mini = {
            enabled = true,
          },
          native_lsp = {
            enabled = true,
          },
          neotree = true,
          noice = true,
          notify = true,
          fzf = true,
          treesitter = true,
          treesitter_context = true,
          which_key = true,
        },
      }
      vim.cmd [[colorscheme catppuccin]]
    end,
  },
}
