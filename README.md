# My Dotfiles

This repository contains my personal dotfiles for a Linux system using Hyprland/i3 window managers, Neovim, and various development tools. It includes automated dependency management and safe synchronization scripts.

## ✨ Features

- 🔗 **GNU Stow Integration** - Clean symlink management
- 📦 **Automated Package Management** - Install all dependencies automatically
- 🔄 **Smart Sync Script** - Safe configuration synchronization (no auto-commits)
- 🔍 **Dependency Checking** - Verify all required packages are installed
- 🎯 **Modular Installation** - Install only what you need
- 🛡️ **Safety Features** - Backups, dry-run mode, conflict detection

## 🚀 Quick Start

### Option 1: Full Automated Installation
```bash
# Clone the repository
git clone https://github.com/mudassirnizamani/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Install everything (packages + dotfiles)
./install.sh --all

# Or install only essentials
./install.sh --core-only
```

### Option 2: Manual Installation
```bash
# Clone repository
git clone https://github.com/mudassirnizamani/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Install dependencies manually
sudo pacman -S stow git yq neovim hyprland wezterm

# Setup dotfiles
stow .
```

## 📦 Package Management

### Install Script Features
```bash
# Install all packages and setup dotfiles
./install.sh --all

# Install specific categories
./install.sh core terminal desktop

# Install without AUR packages
./install.sh --skip-aur core desktop

# Setup dotfiles only (skip packages)
./install.sh --no-stow core

# Show help
./install.sh --help
```

### Package Categories
- **core** - Essential system packages (git, stow, curl, etc.)
- **terminal** - Shell tools (fish, zsh, starship, fzf, etc.)
- **terminal_emulators** - Terminal apps (wezterm, kitty, alacritty, ghostty)
- **development** - Dev tools (neovim, docker, nodejs, python, etc.)
- **desktop** - Window manager (hyprland, waybar, rofi, mako, etc.)
- **fonts** - Font packages (JetBrains Mono Nerd Font, etc.)
- **media** - Media tools (mpv, firefox, obs-studio, etc.)
- **utilities** - System utilities (NetworkManager, blueman, etc.)

### Dependency Checking
```bash
# Check all dependencies
./check-deps.sh

# Check specific configuration dependencies
./check-deps.sh --config-only

# Check specific category
./check-deps.sh --category terminal
```

## 🔄 Configuration Management

### Sync Script (Improved)
```bash
# Sync all configs (safe - no auto-commit)
./sync-dotfiles.sh

# Sync specific configs
./sync-dotfiles.sh hypr nvim wezterm

# Preview changes (dry run)
./sync-dotfiles.sh -n

# Verbose mode with backups
./sync-dotfiles.sh -v

# Quiet mode
./sync-dotfiles.sh -q
```

### Sync Script Features
- ✅ **No Auto-Commit** - Manual control over git commits
- ✅ **Automatic Backups** - In verbose mode
- ✅ **Dependency Checking** - Warns about missing packages
- ✅ **Safety Features** - Dry-run, conflict detection
- ✅ **Smart Ignore** - Skips temporary and build files

## 📂 Directory Structure

```
~/.dotfiles/
├── .config/                    # Application configurations
│   ├── nvim/                  # Neovim configuration
│   ├── hypr/                  # Hyprland window manager
│   ├── wezterm/               # WezTerm terminal emulator
│   ├── ghostty/               # Ghostty terminal emulator
│   ├── kitty/                 # Kitty terminal emulator
│   ├── waybar/                # Status bar
│   └── ...                    # Other app configs
├── install.sh                 # Automated installation script
├── sync-dotfiles.sh          # Configuration sync script
├── check-deps.sh             # Dependency checker
├── packages.yml              # Package definitions
├── auto-cpufreq.conf         # CPU frequency configuration
└── DOTFILES_SYNC_GUIDE.md    # Detailed sync guide
```

## 🛠️ Key Configurations

### Window Manager
- **Primary**: Hyprland (Wayland)
- **Fallback**: i3 (X11)
- **Status Bar**: Waybar (Wayland) / Polybar (X11)
- **Launcher**: Rofi / Wofi
- **Notifications**: Mako

### Development Environment
- **Editor**: Neovim with comprehensive plugin setup
- **Terminal**: WezTerm (with sidebar support), Ghostty, Kitty, Alacritty
- **Shell**: Fish with Starship prompt
- **Multiplexer**: Built into WezTerm and Ghostty

### Terminal Features
- **WezTerm**: Full sidebar/panel support with Ghostty-compatible keybindings
- **Ghostty**: Fast GPU-accelerated terminal with improved split support
- **Unified Keybindings**: Same shortcuts across all terminals

## 🔧 Usage Examples

### Setting Up a New Machine
```bash
# Clone and install everything
git clone https://github.com/mudassirnizamani/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh --all

# Check if everything is working
./check-deps.sh
```

### Adding New Configurations
```bash
# Configure new application in ~/.config/newapp/
# Sync to dotfiles
./sync-dotfiles.sh newapp

# Commit manually when ready
git add .
git commit -m "Add newapp configuration"
git push
```

### Managing Packages
```bash
# Add new packages to packages.yml
# Install specific category
./install.sh development

# Verify dependencies
./check-deps.sh --category development
```

## 🎯 Terminal Sidebar Support

This dotfiles setup includes **WezTerm** as the recommended terminal with full sidebar support:

- `Ctrl+Alt+E` - File manager sidebar (ranger)
- `Ctrl+Alt+M` - System monitor sidebar (htop)
- `Ctrl+Alt+G` - Git interface panel (lazygit)
- `Ctrl+Shift+S/D` - Create left/right splits
- `Ctrl+Alt+H/J/K/L` - Navigate between panes

## 📚 Documentation

- **[Sync Guide](DOTFILES_SYNC_GUIDE.md)** - Detailed sync script documentation
- **[WezTerm Guide](.config/wezterm/README.md)** - Terminal with sidebar support
- **[Ghostty Guide](.config/ghostty/README.md)** - Fast terminal configuration

## 🛡️ Safety Features

- **No Auto-Commits** - Manual control over git operations
- **Automatic Backups** - In verbose sync mode
- **Dependency Validation** - Ensures required packages are installed
- **Conflict Detection** - Safe symlink management
- **Dry Run Mode** - Preview changes before applying

## 🎨 Themes

- **Terminal Theme**: Rose Pine
- **Font**: JetBrains Mono Nerd Font
- **Consistent Theming**: Across all applications

## 🚦 Requirements

- **OS**: Arch Linux / Manjaro (adaptable to other distributions)
- **Package Manager**: pacman
- **AUR Helper**: yay or paru (optional)
- **Dependencies**: Automatically installed by `install.sh`

## 🤝 Contributing

Feel free to use these dotfiles as inspiration for your own setup. If you find improvements or fixes, pull requests are welcome!

## 📄 License

This repository is for personal use. Feel free to adapt and modify for your own needs.