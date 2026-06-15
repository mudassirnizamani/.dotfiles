#!/bin/bash

# Zsh Tools and Plugins Installation Script
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# 1. Install missing tools using apt
print_status "Installing eza and direnv via apt..."
sudo apt update
sudo apt install -y eza direnv

# 2. Install Oh My Zsh
# If ~/.oh-my-zsh is a symlink to an empty directory (from stow), remove it
if [ -L "$HOME/.oh-my-zsh" ]; then
    rm "$HOME/.oh-my-zsh"
fi

# Remove empty tracked directory in dotfiles so stow doesn't recreate it
if [ -d "$HOME/.dotfiles/.oh-my-zsh" ] && [ -z "$(ls -A "$HOME/.dotfiles/.oh-my-zsh")" ]; then
    rm -rf "$HOME/.dotfiles/.oh-my-zsh"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."
    # Keep the existing .zshrc from dotfiles and don't change shell again
    CHSH=no RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    print_success "Oh My Zsh installed"
else
    print_success "Oh My Zsh is already installed"
fi

# 3. Install custom plugins
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    print_status "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
    print_success "zsh-autosuggestions already installed"
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    print_status "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
    print_success "zsh-syntax-highlighting already installed"
fi

print_success "All Zsh tools and plugins have been installed successfully."
echo -e "\n${YELLOW}Please run the following command to apply the changes:${NC}"
echo "exec zsh"
