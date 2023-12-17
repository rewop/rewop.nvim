return {
  'williamboman/mason.nvim',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  config = function()
    local mason = require 'mason'
    local mason_lspconfig = require 'mason-lspconfig'
    local mason_tool_installer = require 'mason-tool-installer'

    mason.setup {
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_unistalled = '✗',
        },
      },
    }
    mason_lspconfig.setup {
      -- list of servers for mason to install
      ensure_installed = {
        'tsserver',
        'html',
        'cssls',
        'tailwindcss',
        'svelte',
        'lua_ls',
        'pyright',
        'gopls',
        'sqlls',
        'jsonls',
        'yamlls',
        'terraformls',
        'marksman',
        'helm_ls',
        'dockerls',
      },
      automatic_installation = true,
    }

    mason_tool_installer.setup {
      ensure_installed = {
        'prettier',
        'stylua',
        'gofumpt',
        'goimports',
        'goimports-reviser',
        'eslint_d',
      },
    }
  end,
}
