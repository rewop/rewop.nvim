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
      registries = {
        'github:mason-org/mason-registry',
        'github:Crashdummyy/mason-registry',
      },
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
        'ts_ls',
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
        'graphql',
        'buf_ls',
        'prismals',
        'ruff',
      },
      automatic_installation = true,
      -- jdtls is started by nvim-jdtls (plugins/jdtls.lua); auto-enabling it would attach a second client.
      automatic_enable = { exclude = { 'jdtls' } },
    }

    mason_tool_installer.setup {
      ensure_installed = {
        'prettier',
        'stylua',
        'gofumpt',
        'goimports',
        'goimports-reviser',
        'eslint_d',
        -- Java (started via nvim-jdtls)
        'jdtls',
        'java-debug-adapter',
        'java-test',
      },
    }
  end,
}
