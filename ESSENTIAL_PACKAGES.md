# Essential Packages Guide

This document lists the most important packages to install when setting up a new system. These are packages that significantly improve daily productivity and workflow.

## 🚀 Must-Have Productivity Tools

### **Navigation & File Management**
- **`zoxide`** - Smart directory jumping (`z` command)
  ```bash
  # After installation, add to shell config:
  eval "$(zoxide init bash)"  # for bash
  eval "$(zoxide init fish)"  # for fish
  eval "$(zoxide init zsh)"   # for zsh
  ```
- **`eza`** - Modern replacement for `ls` with colors and icons
- **`bat`** - Syntax-highlighted `cat` replacement
- **`fd`** - User-friendly `find` replacement
- **`ripgrep` (rg)** - Lightning-fast text search
- **`fzf`** - Fuzzy finder for files, history, processes

### **Terminal & Shell Enhancements**
- **`starship`** - Cross-shell prompt with Git integration
- **`fish`** - User-friendly shell with autocompletion
- **`tmux`** - Terminal multiplexer for session management
- **`ranger`** / **`lf`** / **`nnn`** - Terminal file managers

### **Development Tools**
- **`lazygit`** - Terminal UI for Git operations
- **`btop`** / **`htop`** - System resource monitors
- **`neovim`** - Modern Vim with LSP support
- **`docker`** + **`docker-compose`** - Containerization

### **System Utilities**
- **`stow`** - Dotfiles symlink management
- **`tree`** - Directory structure visualization
- **`curl`** + **`wget`** - Data transfer tools
- **`jq`** - JSON processor

## 🎯 Quick Install Commands

### **Install All Essential Packages**
```bash
# Run the install script with core + terminal categories
./install.sh core terminal development

# Or install everything
./install.sh --all
```

### **Manual Installation (if needed)**
```bash
# Essential productivity tools
sudo pacman -S zoxide eza bat fd ripgrep fzf starship fish

# Development tools
sudo pacman -S neovim lazygit btop docker docker-compose

# System utilities
sudo pacman -S stow tree curl wget jq tmux

# File managers
sudo pacman -S ranger
```

## 🔧 Post-Installation Setup

### **1. Configure Zoxide (Smart CD)**
Add to your shell configuration:

**For Fish shell:**
```fish
# Add to ~/.config/fish/config.fish
zoxide init fish | source
```

**For Bash/Zsh:**
```bash
# Add to ~/.bashrc or ~/.zshrc
eval "$(zoxide init bash)"  # or zsh
```

**Usage:**
```bash
z documents    # Jump to documents folder
z dev proj     # Jump to development/project folder
zi             # Interactive mode with fzf
```

### **2. Configure Starship Prompt**
```bash
# Add to shell config
eval "$(starship init bash)"  # or fish/zsh

# Copy starship config if available
cp .config/starship/starship.toml ~/.config/
```

### **3. Setup Development Environment**
```bash
# Enable Docker service
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

# Configure Git (if not done)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### **4. Install Terminal Emulators**
```bash
# Install preferred terminal emulators
sudo pacman -S wezterm kitty alacritty

# Install Ghostty (AUR)
yay -S ghostty
```

## 📱 Quality of Life Improvements

### **Essential Aliases**
Add these to your shell config:
```bash
# Modern replacements
alias ls='eza --icons'
alias ll='eza -la --icons'
alias cat='bat'
alias find='fd'
alias grep='rg'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias lg='lazygit'

# System
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps aux'
```

### **Essential Environment Variables**
```bash
# Add to shell config
export EDITOR='nvim'
export BROWSER='firefox'
export TERMINAL='wezterm'
```

## 🎨 Visual Enhancements

### **Fonts (Already in packages.yml)**
- **JetBrains Mono Nerd Font** - Programming font with icons
- **Fira Code** - Programming font with ligatures
- **Noto Fonts** - Unicode support

### **Terminal Colors**
- **Rose Pine theme** - Consistent across all terminals
- **Syntax highlighting** with `bat`
- **Directory colors** with `eza`

## 🚀 Workflow Recommendations

### **Daily Usage Pattern**
1. **Open terminal** - `Super+Q` (WezTerm)
2. **Navigate quickly** - `z project-name`
3. **Find files fast** - `fd filename` or `fzf`
4. **Search content** - `rg "search term"`
5. **Git operations** - `lazygit` for visual interface
6. **System monitoring** - `btop` for resource usage

### **Development Workflow**
1. **Jump to project** - `z my-project`
2. **Open editor** - `nvim .`
3. **Terminal multiplexing** - `tmux` or WezTerm tabs
4. **Version control** - `lazygit` for commits
5. **File management** - `ranger` for quick navigation

## 📋 New System Checklist

When setting up a new system:

- [ ] Clone dotfiles repository
- [ ] Run `./install.sh --all`
- [ ] Configure shell (fish/zsh with starship)
- [ ] Setup zoxide with shell integration
- [ ] Configure Git credentials
- [ ] Setup SSH keys
- [ ] Install development languages (Node.js, Python, Rust, Go)
- [ ] Configure Neovim with plugins
- [ ] Setup Docker and enable service
- [ ] Configure terminal emulator (WezTerm recommended)
- [ ] Setup window manager (Hyprland/i3)
- [ ] Test all keybindings and aliases

## 🔗 Resources

- **Zoxide GitHub**: https://github.com/ajeetdsouza/zoxide
- **Starship**: https://starship.rs/
- **Eza**: https://github.com/eza-community/eza
- **Bat**: https://github.com/sharkdp/bat
- **Ripgrep**: https://github.com/BurntSushi/ripgrep
- **Fzf**: https://github.com/junegunn/fzf
- **Lazygit**: https://github.com/jesseduffield/lazygit

## 💡 Pro Tips

1. **Learn the tools gradually** - Start with `zoxide`, `eza`, and `bat`
2. **Customize aliases** - Create shortcuts for your most common commands
3. **Use fzf everywhere** - Integrate with history, files, and Git
4. **Master one file manager** - Become proficient with `ranger` or `lf`
5. **Automate setup** - Use the install.sh script for consistent environments

Remember: These tools are already included in your `packages.yml` and will be installed automatically with `./install.sh`!