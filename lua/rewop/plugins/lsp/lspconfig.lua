return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'saghen/blink.cmp',
    'antosha417/nvim-lsp-file-operations',
  },
  config = function()
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
        keymap.set('n', 'gR', '<CMD>FzfLua lsp_references<CR>', buffer_opts)

        -- go to declaration
        buffer_opts.desc = 'Go to Declaration'
        keymap.set('n', 'gD', vim.lsp.buf.declaration, buffer_opts)

        -- show definitions
        buffer_opts.desc = 'Show LSP definitions'
        keymap.set('n', 'gd', '<CMD>FzfLua lsp_definitions<CR>', buffer_opts)

        -- show implementations
        buffer_opts.desc = 'Show LSP implementations'
        keymap.set('n', 'gI', '<CMD>FzfLua lsp_implementations<CR>', buffer_opts)

        -- show LSP type definitions
        buffer_opts.desc = 'Show LSP type definitions'
        keymap.set('n', 'gt', '<CMD>FzfLua lsp_typedefs<CR>', buffer_opts)

        buffer_opts.desc = 'See available code actions'
        keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, buffer_opts)

        -- show documentation for what is under cursor
        buffer_opts.desc = 'Show documentation for what is under cursor'
        keymap.set('n', 'K', vim.lsp.buf.hover, buffer_opts)

        -- restart LSP
        buffer_opts.desc = 'Restart lsp'
        keymap.set('n', 'grs', '<CMD>LspRestart<CR>', buffer_opts)
      end,
    })

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    vim.diagnostic.config {
      virtual_text = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = ' ',
          [vim.diagnostic.severity.WARN] = ' ',
          [vim.diagnostic.severity.HINT] = ' ',
          [vim.diagnostic.severity.INFO] = ' ',
        },
      },
    }

    -- Major version of the TypeScript installed in `root`'s node_modules (0 if none).
    local function ts_major(root)
      local ok, lines = pcall(vim.fn.readfile, vim.fs.joinpath(root, 'node_modules/typescript/package.json'))
      if not ok then
        return 0
      end
      local ok_json, pkg = pcall(vim.json.decode, table.concat(lines, '\n'))
      return ok_json and tonumber(tostring(pkg.version or ''):match '^(%d+)') or 0
    end

    local function ts_project_root(bufnr)
      return vim.fs.root(bufnr, { { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }, { '.git' } })
    end

    -- TypeScript 7 (native) ships no tsserver.js, so ts_ls silently falls back to its
    -- bundled JS tsserver. Route TS >= 7 projects to the native `tsc --lsp` server instead.
    local default_ts_ls_root = vim.lsp.config.ts_ls.root_dir

    local oxlint_configs = {
      '.oxlintrc.json',
      '.oxlintrc.jsonc',
      'oxlint.config.ts',
      'oxlint.config.mts',
      'oxlint.config.js',
      'oxlint.config.mjs',
    }

    local servers = {
      {
        'ts_ls',
        {
          root_dir = function(bufnr, on_dir)
            local root = ts_project_root(bufnr)
            if root and ts_major(root) >= 7 then
              return
            end
            default_ts_ls_root(bufnr, on_dir)
          end,
        },
      },
      {
        'tsc',
        {
          -- Use the project's own TS 7 binary (lspconfig's default caches it module-locally).
          cmd = function(dispatchers, config)
            local root = (config or {}).root_dir
            local bin = root and vim.fs.joinpath(root, 'node_modules/.bin/tsc')
            if not (bin and vim.fn.executable(bin) == 1) then
              bin = 'tsc'
            end
            return vim.lsp.rpc.start({ bin, '--lsp', '--stdio' }, dispatchers)
          end,
          root_dir = function(bufnr, on_dir)
            local root = ts_project_root(bufnr)
            if root and ts_major(root) >= 7 then
              on_dir(root)
            end
          end,
        },
      },
      {
        -- Only for projects that have an oxlint config; uses the project's own oxlint.
        'oxlint',
        {
          cmd = function(dispatchers, config)
            local bin = 'oxlint'
            local root = (config or {}).root_dir
            if root then
              local found = vim.fs.find('node_modules/.bin/oxlint', { path = root, upward = true })[1]
              bin = found or bin
            end
            return vim.lsp.rpc.start({ bin, '--lsp' }, dispatchers)
          end,
          root_dir = function(bufnr, on_dir)
            local root = vim.fs.root(bufnr, oxlint_configs)
            if root then
              on_dir(root)
            end
          end,
        },
      },
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
      {
        'gopls',
        {
          settings = {
            gopls = {
              -- Keep gopls out of frontend deps, nested worktrees and build output in big monorepos.
              directoryFilters = {
                '-**/node_modules',
                '-**/.worktrees',
                '-**/.claude',
                '-**/.git',
                '-**/dist',
                '-**/build',
              },
            },
          },
        },
      },
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
      {
        -- Default config starts with a nil root on every TSX file; only start with a graphql config.
        'graphql',
        {
          root_dir = function(bufnr, on_dir)
            local root = vim.fs.root(bufnr, function(name)
              return name:match '^%.graphqlrc' ~= nil or name:match '^%.?graphql%.config%.' ~= nil
            end)
            if root then
              on_dir(root)
            end
          end,
        },
      },
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
