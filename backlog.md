# Backlog: LazyVim comparison

Plugin gaps/upgrades found by comparing this config against current LazyVim defaults. Check items off as they're done.

## High priority

- [x] Replace `nvim-cmp` (+ luasnip cmp source) with `blink.cmp` — faster native fuzzy matcher, built-in snippets, zero-config; this is LazyVim's current default completion engine.
- [x] Add `flash.nvim` — enhanced f/t motions, treesitter jump, remote operations. Pure addition, nothing in the config currently covers this.
- [x] Add `persistence.nvim` — per-cwd session save/restore. Pure addition, no session handling exists today.
- [x] Add `mini.ai` — better text objects. `mini.nvim` is already a dependency (via `mini.pairs`/`mini.surround`), so this is a one-line addition.

## Medium priority / optional

- [x] Replace `telescope.nvim` (+ fzf-native, live-grep-args) with `fzf-lua` — already installed as a neogit optional dependency; all `<leader>s*` keymaps and LSP `g*` pickers ported.
- [ ] Evaluate `snacks.picker` as a replacement for `fzf-lua` + `dressing.nvim`. fzf-lua is already fast and fully wired up; snacks folds dressing's input UI in. Taste call, not a clear upgrade.
- [x] Evaluate `snacks.explorer` as a replacement for `nvim-neo-tree` — evaluated, keeping neo-tree: its `git_status`/`buffers` sources are in use (`<leader>eg`/`<leader>eb`) and snacks.explorer is a file tree only. Revisit only if consolidating onto snacks.
- [ ] Evaluate `snacks.notifier` as a replacement for `nvim-notify`. Cosmetic only.
- [ ] Evaluate `snacks.indent` as a replacement for `indent-blankline.nvim`. Lighter, integrates with scope highlighting.
- [ ] Consider `snacks.dashboard` for a start screen. No dashboard exists today.
- [ ] Consider `snacks.zen` / `zen-mode.nvim` for a focus mode. No zen/focus plugin exists today.
- [ ] Add a `lazygit` keymap via the existing `toggleterm.nvim` (or `snacks.lazygit` if snacks is adopted) to complement `fugitive` + `codediff.nvim` + `gitsigns.nvim`.

## Structural (do only if consolidating)

- [ ] Consider migrating `noice.nvim` + `nvim-notify` + `indent-blankline.nvim` onto `snacks.nvim`, which bundles these (and more) into a single dependency — reduces plugin count/maintenance surface, not a functional gap.

## No action needed

- Statusline (`lualine.nvim`), treesitter, mason, lspconfig, conform, nvim-lint, trouble, todo-comments, which-key, comment.nvim, colorizer, dap, harpoon, gitlinker, gx, dadbod, roslyn, nvim-ts-autotag are already aligned with LazyVim's choices.
- Git stack (`fugitive` + `codediff.nvim` + `gitsigns.nvim`) is arguably stronger than LazyVim's default (`gitsigns.nvim` alone).
