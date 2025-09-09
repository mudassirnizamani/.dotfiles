# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a customized Neovim configuration optimized for development in Golang, Flutter, Docker, TypeScript, and Python. The configuration uses Lazy.nvim as the plugin manager and follows a modular plugin organization structure.

## Architecture

### Core Structure
- **Entry Point**: `init.lua` - Loads core modules and initializes Lazy.nvim
- **Core Modules**: Located in `lua/mujheri/`
  - `remaps.lua` - Custom key mappings
  - `sets.lua` - Neovim settings and options
  - `lazy.lua` - Lazy.nvim bootstrap and setup

### Plugin Organization
Plugins are organized into three main categories:
- `lua/plugins/` - General plugins (UI, editor, navigation, etc.)
- `lua/plugins/lang/` - Language-specific plugins (Go, Flutter, Python, TypeScript, etc.)
- `lua/plugins/lsp/` - LSP configuration (Mason, lspconfig)

Each plugin is a separate Lua module that returns a plugin specification table for Lazy.nvim.

## Common Development Tasks

### Plugin Management
```bash
# Open Neovim and use these commands:
:Lazy              # Open Lazy.nvim UI to manage plugins
:Lazy update       # Update all plugins
:Lazy sync         # Sync plugin state with lazy-lock.json
:Mason             # Manage LSP servers, formatters, and linters
```

### Adding a New Plugin
1. Create a new file in the appropriate directory (`lua/plugins/`, `lua/plugins/lang/`, or `lua/plugins/lsp/`)
2. Return a plugin specification table following the Lazy.nvim format
3. The plugin will be automatically loaded due to the `{ import = "plugins" }` pattern in `lazy.lua`

### Modifying Keymaps
- Global keymaps: Edit `lua/mujheri/remaps.lua`
- Plugin-specific keymaps: Edit the plugin's configuration file
- LSP keymaps: Edit `lua/plugins/lsp/lspconfig.lua` (in the LspAttach autocmd)
- Leader key is set to `<space>`

### Python Development Setup
For Python projects, use the provided setup script:
```bash
./fix_python_env_and_secrets.sh [project_directory]
# This creates a project-specific venv with debugpy and base packages
# Activate before opening Neovim: source .venv/bin/activate && nvim
```

## Key Patterns and Conventions

### Plugin Configuration Pattern
```lua
return {
  "plugin/name",
  dependencies = { "required/dependency" },
  event = "VimEnter",  -- or "BufReadPre", "VeryLazy", etc.
  opts = {},           -- or config = function() ... end
}
```

### LSP Server Configuration
LSP servers are managed through Mason and configured in `lua/plugins/lsp/lspconfig.lua`. The pattern uses:
- Mason for automatic installation
- mason-lspconfig for bridging Mason with nvim-lspconfig
- Server-specific settings in the `servers` table

### Keymap Organization
Keymaps are organized by functionality using which-key groups:
- `<leader>a` - Avante (AI)
- `<leader>c` - Code actions
- `<leader>d` - Debug
- `<leader>e` - Explorer (file tree)
- `<leader>f` - Find/Format
- `<leader>g` - Git
- `<leader>s` - Search (Telescope)
- `<leader>x` - Diagnostics (Trouble)

## Important Files
- `lazy-lock.json` - Pinned plugin versions for reproducible installs
- `KEYMAPS.md` - Complete keymap documentation
- `lua/plugins/which-key.lua` - Keymap group definitions