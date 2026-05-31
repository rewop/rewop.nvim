return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'antosha417/nvim-lsp-file-operations',
  },
  config = function()
    local cmp_nvim_lsp = require 'cmp_nvim_lsp'
    local keymap = vim.keymap

    local opts = { noremap = true, silent = true }

    -- Set up LSP keymaps using autocommand (required for new LSP API)
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        local bufnr = ev.buf
        local buffer_opts = vim.tbl_extend('force', opts, { buffer = bufnr })

        -- show definition, reference
        buffer_opts.desc = 'Show LSP References'
        keymap.set('n', 'gR', '<CMD>Telescope lsp_references fname_width=80<CR>', buffer_opts)

        -- go to declaration
        buffer_opts.desc = 'Go to Declaration'
        keymap.set('n', 'gD', vim.lsp.buf.declaration, buffer_opts)

        -- show definitions
        buffer_opts.desc = 'Show LSP definitions'
        keymap.set('n', 'gd', '<CMD>Telescope lsp_definitions<CR>', buffer_opts)

        -- show implementations
        buffer_opts.desc = 'Show LSP implementations'
        keymap.set('n', 'gI', '<CMD>Telescope lsp_implementations<CR>', buffer_opts)

        -- show LSP type definitions
        buffer_opts.desc = 'Show LSP type definitions'
        keymap.set('n', 'gt', '<CMD>Telescope lsp_type_definitions<CR>', buffer_opts)

        buffer_opts.desc = 'See available code actions'
        keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, buffer_opts)

        -- trigger smart rename
        buffer_opts.desc = 'Smart rename'
        keymap.set('n', 'grn', vim.lsp.buf.rename, buffer_opts)

        -- show documentation for what is under cursor
        buffer_opts.desc = 'Show documentation for what is under cursor'
        keymap.set('n', 'K', vim.lsp.buf.hover, buffer_opts)

        -- restart LSP
        buffer_opts.desc = 'Restart lsp'
        keymap.set('n', 'grs', '<CMD>LspRestart<CR>', buffer_opts)
      end,
    })

    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Set the diagnostic symbols in the sigh column
    local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
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
      'buf_ls',
      -- {
      --   'golangci_lint_ls',
      --   {
      --     filetypes = { 'go', 'gomod' },
      --   },
      -- },
      'graphql',
      'dartls',
      'prismals',
    }

    for _, server in ipairs(servers) do
      local config = {
        capabilities = capabilities,
      }
      local servername = ''

      if type(server) == 'table' then
        servername = server[1]
        local serverconfig = server[2]
        config = vim.tbl_deep_extend('force', config, serverconfig)
      elseif type(server) == 'string' then
        servername = server
      end

      -- FIXED: Pass the servername (string) instead of server (which could be a table)
      vim.lsp.enable(servername)
      vim.lsp.config(servername, config)
    end
  end,
}
