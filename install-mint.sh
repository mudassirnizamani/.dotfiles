#!/bin/bash

# Dotfiles Installation Script for Linux Mint (Ubuntu/Debian based)
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_header() {
    echo -e "\n${PURPLE}========================================${NC}"
    echo -e "${PURPLE} $1${NC}"
    echo -e "${PURPLE}========================================${NC}\n"
}

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Update APT packages
print_header "Updating System"
sudo apt update && sudo apt upgrade -y

# Core Packages
print_header "Installing Core Dependencies"
sudo apt install -y build-essential git stow curl wget unzip tree htop neofetch zsh tmux ripgrep fd-find fzf

# Create fdfind symlink if not exists (Debian specific)
if [ ! -L ~/.local/bin/fd ] && [ -x "$(command -v fdfind)" ]; then
    mkdir -p ~/.local/bin
    ln -s $(which fdfind) ~/.local/bin/fd
    print_success "Created fd symlink for fdfind"
fi

# Neovim (AppImage to get a newer version, as apt repo version is usually old)
print_header "Installing Neovim"
if ! command -v nvim &> /dev/null; then
    print_status "Downloading Neovim AppImage..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
    chmod u+x nvim-linux-x86_64.appimage
    sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
    print_success "Neovim installed"
else
    print_success "Neovim already installed"
fi

# Starship Prompt
print_header "Installing Starship"
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    print_success "Starship installed"
else
    print_success "Starship already installed"
fi

# Zoxide
print_header "Installing Zoxide"
if ! command -v zoxide &> /dev/null; then
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    print_success "Zoxide installed"
else
    print_success "Zoxide already installed"
fi

# Link Dotfiles
print_header "Setting up Dotfiles with Stow"
if [[ ! -d "$SCRIPT_DIR/.config" ]]; then
    print_error "No .config directory found in dotfiles"
    exit 1
fi

cd "$SCRIPT_DIR"
if stow -v .; then
    print_success "Dotfiles linked successfully"
else
    print_error "Stow failed - there might be conflicts"
    print_status "You may need to backup existing config files"
fi

# Change default shell to zsh
print_header "Setting Default Shell"
if [[ "$SHELL" != "$(which zsh)" ]]; then
    print_status "Changing default shell to zsh..."
    chsh -s $(which zsh)
    print_success "Default shell changed to zsh (will take effect on next login)"
else
    print_success "Zsh is already the default shell"
fi

print_header "Installation Complete!"
echo -e "\n${YELLOW}Next steps:${NC}"
echo "1. Restart your terminal or run: exec zsh"
echo "2. Ensure ~/.local/bin is in your PATH in .zshrc"
