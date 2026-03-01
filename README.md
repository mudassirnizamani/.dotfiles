# My Dotfiles

This repository contains my personal dotfiles tailored for an **Omarchy** Linux system. It focuses on configuring shell environments (Zsh), terminal tools, and developer utilities since Omarchy natively manages the desktop environment and window manager.

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
- **terminal** - Shell tools (zsh, starship, fzf, etc.)
- **fonts** - Font packages (JetBrains Mono Nerd Font, etc.)

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
./sync-dotfiles.sh tmux zsh

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
│   ├── starship.toml          # Example tool config
│   └── ...                    # Other app configs
├── install.sh                 # Automated installation script
├── sync-dotfiles.sh          # Configuration sync script
├── check-deps.sh             # Dependency checker
├── packages.yml              # Package definitions
├── auto-cpufreq.conf         # CPU frequency configuration
└── DOTFILES_SYNC_GUIDE.md    # Detailed sync guide
```



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



## 📚 Documentation

- **[Essential Packages](ESSENTIAL_PACKAGES.md)** - Must-have tools for new system setup
- **[Sync Guide](DOTFILES_SYNC_GUIDE.md)** - Detailed sync script documentation

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

- **OS**: Omarchy (Arch Linux base)
- **Package Manager**: pacman
- **AUR Helper**: yay or paru (optional)
- **Dependencies**: Automatically installed by `install.sh`

## 🤝 Contributing

Feel free to use these dotfiles as inspiration for your own setup. If you find improvements or fixes, pull requests are welcome!

## 📄 License

This repository is for personal use. Feel free to adapt and modify for your own needs.