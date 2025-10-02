# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a comprehensive dotfiles repository for an Arch Linux/Manjaro system, managing configurations for:
- **Window Managers**: Hyprland (Wayland) and i3 (X11 fallback)
- **Terminal Emulators**: WezTerm (primary), Ghostty, Kitty, Alacritty
- **Development Environment**: Neovim with extensive plugin ecosystem
- **Shell**: Zsh with Oh My Zsh, Fish support
- **System Tools**: Automated package management, dependency checking, and safe synchronization

The repository uses **GNU Stow** for symlink management and includes automated scripts for installation, synchronization, and dependency verification.

## Key Commands

### Installation & Setup
```bash
# Full installation (packages + dotfiles)
./install.sh --all

# Install only core packages (no optional/media packages)
./install.sh --core-only

# Install specific package categories
./install.sh core terminal desktop development

# Install without AUR packages
./install.sh --skip-aur core desktop

# Setup dotfiles only (skip package installation)
./install.sh --no-stow core
```

### Configuration Synchronization
```bash
# Sync all configs from system to dotfiles repo
./sync-dotfiles.sh

# Sync specific configurations
./sync-dotfiles.sh hypr nvim wezterm

# Preview changes (dry run)
./sync-dotfiles.sh -n

# Verbose mode with automatic backups
./sync-dotfiles.sh -v

# Quiet mode
./sync-dotfiles.sh -q
```

### Dependency Management
```bash
# Check all package dependencies
./check-deps.sh

# Check specific configuration dependencies
./check-deps.sh --config-only

# Check specific package category
./check-deps.sh --category terminal
```

## Architecture & Structure

### Core Components

**Directory Layout:**
```
~/.dotfiles/
├── .config/                    # Application configurations (managed by stow)
│   ├── nvim/                  # Neovim (modular Lua config)
│   ├── hypr/                  # Hyprland window manager
│   ├── wezterm/               # WezTerm terminal emulator
│   ├── ghostty/               # Ghostty terminal
│   ├── waybar/                # Status bar (Wayland)
│   └── ...                    # Other app configs
├── install.sh                 # Package installation script
├── sync-dotfiles.sh          # Config synchronization script
├── check-deps.sh             # Dependency verification script
├── packages.yml              # YAML-based package definitions
├── .zshrc                    # Zsh configuration
├── .tmux.conf                # Tmux configuration
└── auto-cpufreq.conf         # CPU frequency management
```

**Package Management System:**
- `packages.yml` defines all packages organized by category (core, terminal, development, desktop, fonts, media, utilities, etc.)
- `install.sh` reads from `packages.yml` using `yq` (YAML parser)
- Categories: `core`, `terminal`, `terminal_emulators`, `development`, `desktop`, `i3wm`, `fonts`, `media`, `utilities`, `optional`, `aur`, `languages`, `gaming`
- Supports both official Arch repositories and AUR packages

### Neovim Configuration

**Structure:**
- Entry point: `init.lua`
- Core modules: `lua/mujheri/` (remaps, sets, lazy.lua)
- Plugins: `lua/plugins/` (general), `lua/plugins/lang/` (language-specific), `lua/plugins/lsp/` (LSP)
- Plugin manager: Lazy.nvim with automatic loading
- Supported languages: Go, Flutter, Dart, Python, TypeScript, Rust
- Current theme: Flow (dark, transparent, orange fluo)

**Key Neovim Commands:**
```vim
:Lazy              " Manage plugins
:Mason             " Manage LSP servers, formatters, linters
```

### Hyprland Configuration

**Features:**
- Main config: `hyprland.conf`
- Additional configs: `env_var.conf`, `media-binds.conf`, `rog-g15-strix-2021-binds.conf`
- Scripts: GPU screen recording, microphone noise reduction (RNNoise), dual monitor setup
- Audio: Advanced PipeWire/PulseAudio configuration with noise reduction support

### Terminal Emulator Configuration

**WezTerm (Primary):**
- Dark theme with custom color scheme
- Ghostty-like keybindings for consistency
- Sidebar/panel support (Ctrl+Alt+E for ranger, Ctrl+Alt+M for htop, Ctrl+Alt+G for lazygit)
- Split pane support with Ctrl+Shift+S/D
- Pane navigation: Ctrl+Alt+H/J/K/L
- Font: JetBrainsMono Nerd Font, 13.6pt
- Transparent background (0.25 opacity)

## Common Workflows

### Adding New Configuration
```bash
# 1. Configure application in ~/.config/newapp/
# 2. Sync to dotfiles repository
./sync-dotfiles.sh newapp

# 3. Review changes
git status

# 4. Commit when ready (manual control, no auto-commit)
git add .config/newapp
git commit -m "Add newapp configuration"
git push
```

### Managing Packages
```bash
# 1. Edit packages.yml to add new packages
# 2. Install specific category
./install.sh development

# 3. Verify installation
./check-deps.sh --category development
```

### Setting Up New Machine
```bash
# Clone repository
git clone https://github.com/mudassirnizamani/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Full automated installation
./install.sh --all

# Verify everything
./check-deps.sh
```

## Important Behaviors

### Sync Script Safety Features
- **No auto-commits**: Manual git control prevents accidental broken states
- **Automatic backups**: Created in verbose mode (`-v`) at `~/.dotfiles-backup/`
- **Symlink detection**: Won't touch already-symlinked files
- **Smart ignore patterns**: Skips temporary files (*.tmp, *.swp, *.log, node_modules, __pycache__, etc.)
- **Dependency checking**: Warns about missing packages before syncing

### Package Categories
When installing, you can target specific categories:
- `core`: Essential system tools (git, stow, curl, wget, htop, btop, neofetch)
- `terminal`: Shell tools (fish, zsh, starship, zoxide, eza, bat, ripgrep, fd, fzf, tmux, ranger)
- `terminal_emulators`: wezterm, ghostty, kitty, alacritty
- `development`: neovim, docker, nodejs, python, rustup, go, jq, yq
- `desktop`: hyprland, waybar, wofi, rofi, mako, pipewire, xdg-desktop-portal-hyprland
- `fonts`: JetBrains Mono Nerd Font, Fira Code, Noto Fonts
- `media`: mpv, firefox, chromium, obs-studio
- `utilities`: NetworkManager, blueman, pavucontrol, thunar

### File Ignore Patterns
The sync script automatically ignores:
- Git files: `.git`, `.gitignore`
- Temporary files: `*.tmp`, `*.swp`, `*.bak`, `*~`
- System files: `.DS_Store`, `Thumbs.db`
- Log/cache: `*.log`, `*.cache`
- Build artifacts: `node_modules`, `__pycache__`, `.pytest_cache`, `.mypy_cache`
- Python bytecode: `*.pyc`, `*.pyo`

## Theming & Appearance

- **Terminal Theme**: Dark custom theme with orange accents
- **Neovim Theme**: Flow (dark, transparent, orange fluo)
- **Font**: JetBrains Mono Nerd Font (system-wide)
- **Window Manager**: Hyprland with transparent terminal backgrounds
- **Status Bar**: Waybar (Wayland) / Polybar (X11)
