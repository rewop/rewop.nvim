# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal Neovim configuration (rewop.nvim) originally forked from kickstart.nvim. The configuration is organized into a modular Lua-based structure with lazy.nvim as the plugin manager.

## Architecture

### Initialization Flow

1. `init.lua` - Entry point that checks for VSCode integration
   - If running in VSCode: loads `rewop.vscode`
   - Otherwise: loads `rewop.core` and `rewop.lazy`

2. `lua/rewop/core/init.lua` - Core configuration loader
   - Sets leader keys (space)
   - Loads options, keymaps, and autogroups

3. `lua/rewop/lazy.lua` - Plugin manager setup
   - Auto-installs lazy.nvim if missing
   - Imports plugins from `rewop.plugins` and `rewop.plugins.lsp`

### Directory Structure

- `lua/rewop/core/` - Core Neovim configuration (options, keymaps, autogroups)
- `lua/rewop/plugins/` - Plugin configurations (each plugin in its own file)
- `lua/rewop/plugins/lsp/` - LSP-specific configurations (lspconfig, mason)
- `lua/rewop/vscode/` - VSCode-specific configuration
- `lua/rewop/extensions/` - Custom extensions (e.g., codecompanion integrations)

### Plugin Management

Plugins are managed via lazy.nvim with a per-file configuration pattern. Each plugin gets its own file in `lua/rewop/plugins/` that returns a lazy.nvim spec table.

## Development Commands

### Plugin Management

```bash
# Sync plugins (install missing, update, clean)
nvim --headless "+Lazy! sync" +qa

# Open Lazy UI (from within nvim)
:Lazy
# Or use keymap: <leader>l
```

### Formatting

```bash
# Format Lua files with stylua
stylua .

# Format from within nvim
# <leader>f - Format current buffer (conform.nvim)
```

Configuration: `.stylua.toml` (2 spaces, single quotes, no call parentheses)

Formatters by filetype (lua/rewop/plugins/conform.lua):
- Lua: stylua
- JS/TS/React: prettierd, prettier
- Go: goimports, gofumpt
- SQL: sqlfluff
- Python: ruff
- Proto: buf

Disable auto-format: `:FormatDisable` (global) or `:FormatDisable!` (buffer-only)

### Linting

Linters configured in `lua/rewop/plugins/nvim-lint.lua`:
- JS/TS/React: eslint_d

Trigger linting manually: `<leader>cl`

### LSP Management

LSP servers are configured in two places:

1. `lua/rewop/plugins/lsp/mason.lua` - Auto-installation via Mason
2. `lua/rewop/plugins/lsp/lspconfig.lua` - Server configuration and keybindings

Key LSP servers: ts_ls, lua_ls, pyright, gopls, sqlls, terraformls, tailwindcss, astro, prismals, and more.

From within nvim:
```
:Mason              # Open Mason UI to manage LSP servers
:LspRestart         # Restart LSP (or use: grs)
:LspInfo           # Show LSP client info
```

### Debugging

DAP (Debug Adapter Protocol) is configured in `lua/rewop/plugins/dap.lua` with nvim-dap-go support.

Debug keymaps:
- `F5` - Continue
- `F10` - Step over
- `F11` - Step into
- `F12` - Step out
- `<leader>q` - Toggle breakpoint
- `<leader>D` - Open DAP UI

## Key Configurations

### LSP Setup Pattern

The configuration uses the new Neovim 0.11+ LSP API (`vim.lsp.enable()` and `vim.lsp.config()`) instead of the legacy lspconfig.setup() pattern. When adding new LSP servers:

1. Add server name to `ensure_installed` in `lua/rewop/plugins/lsp/mason.lua`
2. Add server configuration to the `servers` table in `lua/rewop/plugins/lsp/lspconfig.lua`

Servers can be specified as:
- String: `'ts_ls'` (uses default config)
- Table: `{ 'lua_ls', { settings = { ... } } }` (custom config)

### Keymap Organization

Leader key is `<space>`. Major keymap prefixes:
- `<leader>b` - Buffer operations (delete, switch, etc.)
- `<leader>s` - Search/Telescope (files, grep, diagnostics)
- `<leader>c` - Code actions (LSP, linting)
- `<leader>t` - Tab management
- `<leader>w` - Write/save
- `g` prefix - LSP navigation (gd, gR, gI, gt, grn, grs)

See `lua/rewop/core/keymaps.lua` for complete list.

### Dual Environment Support

The config supports both regular Neovim and VSCode Neovim extension:
- Check `vim.g.vscode` to detect environment
- VSCode mode loads minimal config from `lua/rewop/vscode/init.lua`

## Important Notes

- When modifying plugin configs, changes take effect after restarting nvim or using `:Lazy reload {plugin}`
- Format-on-save is enabled by default via conform.nvim
- LSP keymaps are set up via LspAttach autocmd, so they only activate when LSP attaches to a buffer
- The configuration expects ripgrep to be installed for Telescope functionality
