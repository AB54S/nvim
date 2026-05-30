# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a minimal Neovim configuration (`~/.config/nvim`). It uses **vim-plug** as a plugin manager and includes basic editor settings, two plugins (Catppuccin colorscheme + nvim-tree), and custom keybindings.

## File Structure

- `init.vim` — Single config file (Vimscript). Contains:
  - Plugin declarations via vim-plug
  - Core editor settings
  - Plugin configuration (Lua blocks embedded in Vimscript)
  - Custom keybindings
  - Autocommands

## Common Commands

**Testing Changes:**
- Open nvim: `nvim`
- Reload config: `:source ~/.config/nvim/init.vim`
- Check for errors: `:messages` (check for any error output)

**Plugin Management:**
- Install plugins: `:PlugInstall`
- Update plugins: `:PlugUpdate`
- Check plugin status: `:PlugStatus`

## Architecture Notes

**Plugin System:**
- Uses vim-plug as the plugin manager (declare plugins in `plug#begin()...plug#end()`)
- Plugins are sourced automatically after the `plug#end()` call

**Lua Blocks:**
- Plugin configuration is embedded in `lua << EOF...EOF` blocks within Vimscript
- This allows Neovim-specific Lua configuration while keeping everything in one file

**Keybinding Convention:**
- Space is the leader key (`mapleader = " "`)
- Most navigation and file operations are mapped to `<leader>` combinations
- Normal mode prefixes: `<leader>w` (save), `<leader>q` (quit), `<leader>e` (explorer)
- Window navigation uses Ctrl+hjkl pattern
- Visual mode has J/K for line movement

## Key Configuration Areas

1. **Theme** — Catppuccin mocha colorscheme (customizable in the COLORSCHEME section)
2. **File Explorer** — nvim-tree with 30-char width (configurable in PLUGIN CONFIGURATION)
3. **LSP & Completion** — gopls for Go, nvim-cmp for autocomplete (see LSP section below)
4. **Syntax Highlighting** — Treesitter provides better highlighting for Go, Lua, Vim
5. **Indentation** — 2 spaces (tabs → spaces conversion enabled)
6. **Search** — Case-insensitive by default, smart-case when uppercase detected
7. **Cleanup** — Trailing whitespace auto-removed on save

## LSP (Language Server Protocol) Setup

**Supported Languages:** Go (via gopls)

**Required Setup:**
- First run: `:PlugInstall` to install plugins
- Then: `:TSUpdate` to install Treesitter parsers
- Go must be installed; gopls will auto-install on first use

**LSP Keybindings:**
- `gd` — Go to definition
- `gD` — Go to type definition
- `K` — Hover (see type info, docs)
- `Space+rn` — Rename symbol
- `Space+ca` — Code actions (quick fixes, etc.)
- `Space+f` — Format file
- `Ctrl+Space` — Trigger autocomplete manually (often auto-triggered)
- `Tab/Shift+Tab` — Navigate autocomplete menu
- `Enter` — Confirm autocomplete selection

## Setup Instructions

To use Go LSP features after adding these plugins:

```bash
# 1. Install plugins in Neovim
nvim
:PlugInstall

# 2. Update Treesitter parsers
:TSUpdate

# 3. Reload config
:source ~/.config/nvim/init.vim
```

**gopls** will auto-install on first use when you open a .go file. Ensure Go is installed.

## Troubleshooting LSP

- **Autocomplete not showing?** Press `Ctrl+Space` to trigger manually
- **gopls not installing?** Ensure Go is installed: `go version`
- **Errors on startup?** Check `:messages` for any plugin load errors
- **LSP not attaching?** Check `:LspInfo` to see if gopls attached to the buffer

## Editing Notes

- Single config file keeps everything simple but means large expansions may warrant splitting into separate files or a more structured layout (lua/ directory with separate modules)
- Comments use the `" ============================================================================` style for section headers
- When adding new plugins, follow the existing pattern: simple plugin declarations with inline Lua configuration
