# 🚀 Neovim Configuration

A modern, feature-rich Neovim configuration optimized for multi-language development with a focus on **Go**, **Flutter**, **Docker**, **TypeScript**, and **Python**. Built with [Lazy.nvim](https://github.com/folke/lazy.nvim) for fast startup and organized plugin management.

## ✨ Features

### 🎯 Core Capabilities
- **Lightning-fast startup** with lazy-loading plugins
- **Intelligent LSP integration** with auto-installation via Mason
- **Advanced completion** with nvim-cmp and snippets
- **Git integration** with fugitive, gitsigns, and git-blame
- **Fuzzy finding** with Telescope for files, symbols, and more
- **Debugging support** with nvim-dap for multiple languages
- **AI-powered assistance** with Avante integration

### 🛠 Development Tools
- **Formatter integration** - Auto-formatting on save
- **Linting and diagnostics** - Real-time error detection
- **File explorer** - Neo-tree with git status
- **Terminal integration** - Built-in terminal management
- **Session management** - Persistent sessions across restarts
- **Markdown preview** - Live preview for documentation

### 🎨 UI & Experience
- **Beautiful themes** - Catppuccin and other modern colorschemes
- **Status line** - Informative lualine setup
- **Which-key integration** - Discoverable keymaps with hints
- **Smooth scrolling** - Enhanced navigation experience
- **Dashboard** - Customizable startup screen

## 📁 Project Structure

```
~/.config/nvim/
├── init.lua                    # Entry point
├── lazy-lock.json             # Plugin version lock file
├── lua/
│   ├── mujheri/              # Core configuration modules
│   │   ├── lazy.lua          # Lazy.nvim setup
│   │   ├── remaps.lua        # Global keymaps
│   │   └── sets.lua          # Neovim options
│   └── plugins/              # Plugin configurations
│       ├── lang/             # Language-specific plugins
│       └── lsp/              # LSP-related configurations
├── KEYMAPS.md               # Complete keymap reference
├── LSP-KEYBINDINGS.md       # LSP-specific keymaps
└── fix_python_env_and_secrets.sh  # Python setup script
```

## 🚀 Quick Start

### Prerequisites
- **Neovim 0.9+** 
- **Git**
- **Node.js** (for LSP servers)
- **Python 3.8+** (for Python development)
- **Go** (for Go development)
- **A Nerd Font** (recommended: JetBrains Mono Nerd Font)

### Installation

1. **Backup existing config** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone this configuration**:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

3. **Launch Neovim**:
   ```bash
   nvim
   ```
   
   Lazy.nvim will automatically install all plugins on first run.

4. **Install LSP servers** (optional - Mason will prompt you):
   ```vim
   :Mason
   ```

### Python Development Setup
For Python projects, use the provided setup script:
```bash
cd your-python-project
~/.config/nvim/fix_python_env_and_secrets.sh .
source .venv/bin/activate && nvim
```

## ⌨️ Key Mappings

**Leader key**: `<Space>`

### Essential Shortcuts
| Keymap | Mode | Action |
|--------|------|---------|
| `<leader>ff` | Normal | Find files |
| `<leader>fg` | Normal | Live grep |
| `<leader>e` | Normal | Toggle file explorer |
| `<leader>gg` | Normal | LazyGit |
| `<leader>xx` | Normal | Toggle trouble |
| `<C-s>` | All | Save file |
| `jj` | Insert | Exit insert mode |

### LSP Keymaps (Buffer-local)
| Keymap | Action |
|--------|---------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |

See [KEYMAPS.md](KEYMAPS.md) for the complete reference.

## 🔧 Customization

### Adding New Plugins
Create a new file in `lua/plugins/`:
```lua
-- lua/plugins/your-plugin.lua
return {
  "author/plugin-name",
  event = "VeryLazy",
  opts = {
    -- your configuration
  },
}
```

### Language Support
Language-specific plugins go in `lua/plugins/lang/`. The configuration automatically loads all files in the plugins directory.

### Modifying Keymaps
- **Global keymaps**: Edit `lua/mujheri/remaps.lua`
- **Plugin-specific**: Edit the respective plugin file
- **LSP keymaps**: Edit `lua/plugins/lsp/lspconfig.lua`

## 🎯 Supported Languages

| Language | LSP | Formatter | Debugger | Features |
|----------|-----|-----------|----------|----------|
| **Go** | ✅ gopls | ✅ gofmt | ✅ delve | Auto-imports, tests |
| **Python** | ✅ pyright | ✅ black/ruff | ✅ debugpy | Virtual env support |
| **TypeScript/JS** | ✅ tsserver | ✅ prettier | ✅ node | React support |
| **Rust** | ✅ rust-analyzer | ✅ rustfmt | ✅ codelldb | Cargo integration |
| **Lua** | ✅ lua-ls | ✅ stylua | - | Neovim API support |
| **Docker** | ✅ dockerls | - | - | Dockerfile support |
| **Flutter/Dart** | ✅ dartls | ✅ dart_format | ✅ flutter | Widget inspection |

## 📖 Documentation

- [KEYMAPS.md](KEYMAPS.md) - Complete keymap reference
- [LSP-KEYBINDINGS.md](LSP-KEYBINDINGS.md) - LSP-specific shortcuts
- [CLAUDE.md](CLAUDE.md) - Development guidelines for AI assistance

## 🤝 Contributing

This is a personal configuration, but suggestions and improvements are welcome! Feel free to:
- Open an issue for bugs or feature requests
- Submit a PR with improvements
- Share your customizations

## 📝 License

This configuration is provided as-is for educational and personal use. Feel free to fork and modify to suit your needs.

---

**Happy coding!** 🎉
