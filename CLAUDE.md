# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Neovim configuration (`~/.config/nvim`). It uses **lazy.nvim** as the plugin manager and is contained entirely in a single `init.lua` file. The aesthetic is LazyVim-inspired (Snacks, neo-tree, bufferline, lualine, noice, catppuccin-mocha, which-key, gitsigns) without using the LazyVim framework itself.

## File Structure

- `init.lua` — Single config file (pure Lua). Contains:
  - lazy.nvim bootstrap
  - Plugin declarations + configuration (all inline in `require("lazy").setup({...})`)
  - Core editor options (LazyVim defaults)
  - LSP setup (gopls)
  - Keymaps
  - Autocmds

## Common Commands

**Testing Changes:**
- Open nvim: `nvim`
- Reload config: `:source ~/.config/nvim/init.lua`
- Check for errors: `:messages`
- Headless smoke test: `nvim --headless -c "lua print('OK')" -c "qa"`

**Plugin Management (lazy.nvim):**
- Open lazy UI: `:Lazy` (or `<leader>l`)
- Install plugins: `:Lazy install`
- Update plugins: `:Lazy update`
- Check plugin status: `:Lazy`

**Treesitter:**
- Update parsers: `:TSUpdate`

## Architecture Notes

**Plugin System:**
- lazy.nvim loads plugins; high-priority plugins (`priority = 1000, lazy = false`) load immediately
- Other plugins use `event =`, `cmd =`, or `keys =` for lazy-loading
- Snacks.nvim must be `priority = 1000, lazy = false` — many things depend on `Snacks.*` globals

**Key Plugins:**
| Plugin | Role |
|---|---|
| `catppuccin` | Colorscheme (mocha) |
| `folke/snacks.nvim` | Dashboard, picker, explorer, indent guides, scroll, notifier, terminal, words |
| `nvim-neo-tree/neo-tree.nvim` | File explorer (left sidebar) |
| `akinsho/bufferline.nvim` | Buffer tab bar |
| `nvim-lualine/lualine.nvim` | Status line |
| `folke/noice.nvim` | Fancy cmdline/messages UI |
| `folke/which-key.nvim` | Keymap popup hints |
| `lewis6991/gitsigns.nvim` | Git hunk signs |
| `nvim-treesitter` | Syntax highlighting |
| `neovim/nvim-lspconfig` | LSP (gopls for Go) |
| `hrsh7th/nvim-cmp` | Autocomplete |
| `numToStr/Comment.nvim` | gcc/gc commenting |
| `windwp/nvim-autopairs` | Auto-close brackets |
| `MeanderingProgrammer/render-markdown.nvim` | In-buffer markdown rendering (no external server) |
| `stevearc/conform.nvim` | Format on save (markdownlint-cli2 --fix for markdown) |
| `mfussenegger/nvim-lint` | Async linting (markdownlint-cli2 diagnostics for markdown) |

## Key Configuration Areas

1. **Theme** — Catppuccin mocha (configured in the catppuccin plugin block)
2. **File Explorer** — neo-tree, `<leader>e` to toggle via Snacks.explorer(), `<leader>fe` for neo-tree directly
3. **Picker** — Snacks.picker replaces telescope: `<leader><space>` smart find, `<leader>ff` files, `<leader>/` grep
4. **LSP** — gopls for Go; `gd` uses Snacks.picker.lsp_definitions(), `K` for hover, `<leader>rn` rename
5. **Indentation** — 2 spaces (tabs → spaces)
6. **Search** — Case-insensitive by default, smart-case when uppercase typed
7. **Trailing whitespace** — Auto-removed on save (markdown excluded — see below)
8. **Markdown linting/formatting** — `markdownlint-cli2` (brew-installed, not mason) via conform.nvim (`--fix` on `BufWritePre`) and nvim-lint (diagnostics on read/save/insert-leave). nvim-lint's cwd is pinned to the file's directory so repo-local `.markdownlint.json`/`.yaml` configs are honored regardless of nvim's launch directory. Trailing-whitespace stripping skips markdown so intentional two-space hard line breaks survive; MD009 handles real stray whitespace instead.

## Keybinding Highlights

- `<leader>` = Space
- `jk` → Esc (insert mode)
- `<CR>` → smart Enter: auto-closes `{` and `(` with proper indentation
- `<S-h>` / `<S-l>` → prev/next buffer
- `<C-h/j/k/l>` → window navigation
- `<A-j/k>` → move lines up/down
- `<C-s>` → save file
- `<leader>e` → file explorer
- `<leader>ff` → find files, `<leader>/` → grep
- `<c-/>` → toggle terminal
- `Cmd+Shift+V` / `<leader>um` → toggle markdown render (raw ↔ rendered). Markdown renders on by default; requires the Ghostty `keybind` in `~/.config/ghostty/config` to forward Cmd+Shift+V (default binding is paste).

## LSP Setup

**Supported Languages:** Go (via gopls)

gopls path: `~/go/bin/gopls` (auto-installed on first use when you open a .go file)

**LSP Keybindings:**
- `gd` — Go to definition (via Snacks picker)
- `gD` — Go to declaration
- `gr` — References
- `K` — Hover
- `<leader>rn` — Rename symbol
- `<leader>ca` — Code actions
- `<leader>cf` — Format file

## Setup Instructions

On first launch, lazy.nvim will auto-bootstrap and install all plugins:

```bash
nvim  # lazy.nvim installs everything automatically
# then inside nvim:
:TSUpdate   # install Treesitter parsers
```

## Editing Notes

- Single file keeps everything simple. If it grows large, consider splitting into `lua/` modules.
- Comments use `-- ===...===` style for section headers.
- When adding plugins, follow the existing lazy.nvim spec pattern inside `require("lazy").setup({...})`.
- `fillchars` fold glyphs are omitted intentionally — Nerd Font glyphs can fail Neovim's 1-column-width validation.
