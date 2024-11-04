return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'antosha417/nvim-lsp-file-operations',
  },
  config = function()
    local lspconfig = require 'lspconfig'
    local cmp_nvim_lsp = require 'cmp_nvim_lsp'
    local keymap = vim.keymap

    local opts = { noremap = true, silent = true }
    local on_attach = function(_, bufnr)
      opts.buffer = bufnr

      -- show definition, reference
      opts.desc = 'Show LSP References'
      keymap.set('n', 'gR', '<CMD>Telescope lsp_references fname_width=80<CR>', opts)

      -- go to declaration
      opts.desc = 'Go to Declaration'
      keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)

      -- show definitions
      opts.desc = 'Show LSP definitions'
      keymap.set('n', 'gd', '<CMD>Telescope lsp_definitions<CR>', opts)

      -- show implementations
      opts.desc = 'Show LSP implementations'
      keymap.set('n', 'gI', '<CMD>Telescope lsp_implementations<CR>', opts)

      -- show LSP type definitions
      opts.desc = 'Show LSP type definitions'
      keymap.set('n', 'gt', '<CMD>Telescope lsp_type_definitions<CR>', opts)

      opts.desc = 'See available code actions'
      keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)

      -- trigger smart rename
      opts.desc = 'Smart rename'
      keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

      -- show documentation for what is under cursor
      opts.desc = 'Show documentation for what is under cursor'
      keymap.set('n', 'K', vim.lsp.buf.hover, opts)

      -- restart LSP
      opts.desc = 'Restart lsp'
      keymap.set('n', '<leader>rs', '<CMD>LspRestart<CR>', opts)
    end

    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Set the diagnostic symbols in the sigh column
    local signs = { Error = ' ', Warn = ' ', Hint = '󰠠 ', Info = ' ' }
    for type, icon in pairs(signs) do
      local hl = 'DiagnosticSign' .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
    end

    local servers = {
      'ts_ls',
      'html',
      'cssls',
      'tailwindcss',
      'svelte',
      {
        'lua_ls',
        {
          settings = { -- custom settings for lua
            Lua = {
              runtime = { version = 'LuaJIT' },
              -- make the language server recognize "vim" global
              diagnostics = {
                globals = { 'vim' },
              },
              workspace = {
                checThirdParty = false,
                -- make language server aware of runtime files
                library = {
                  [vim.fn.expand '$VIMRUNTIME/lua'] = true,
                  [vim.fn.stdpath 'config' .. '/lua'] = true,
                },
              },
            },
          },
        },
      },
      'pyright',
      'gopls',
      'sqlls',
      'jsonls',
      'yamlls',
      'terraformls',
      'marksman',
      -- 'spectral',
      'helm_ls',
      'dockerls',
      'astro',
      'bufls',
      {
        'golangci_lint_ls',
        {
          filetypes = { 'go', 'gomod' },
        },
      },
    }

    for _, server in ipairs(servers) do
      local config = {
        capabilities = capabilities,
        on_attach = on_attach,
      }
      local servername = ''

      if type(server) == 'table' then
        servername = server[1]
        local serverconfig = server[2]
        config = vim.tbl_deep_extend('force', config, serverconfig)
      elseif type(server) == 'string' then
        servername = server
      end

      lspconfig[servername].setup(config)
    end
  end,
}
