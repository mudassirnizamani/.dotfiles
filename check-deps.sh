#!/bin/bash

# Dependency Checker for Dotfiles
# Checks if all required packages are installed for your configurations

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_FILE="$SCRIPT_DIR/packages.yml"

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if yq is available
check_yq() {
    if ! command -v yq &> /dev/null; then
        print_error "yq is required for parsing packages.yml"
        print_status "Install with: sudo pacman -S yq"
        exit 1
    fi
}

# Parse packages from YAML file
parse_packages() {
    local category="$1"
    if [[ ! -f "$PACKAGES_FILE" ]]; then
        print_error "packages.yml not found!"
        exit 1
    fi

    yq eval ".${category}[]" "$PACKAGES_FILE" 2>/dev/null || echo ""
}

# Check packages in a category
check_category() {
    local category="$1"
    local description="$2"

    echo -e "\n${BLUE}=== Checking $description ===${NC}"

    local packages=($(parse_packages "$category"))

    if [[ ${#packages[@]} -eq 0 ]]; then
        print_warning "No packages found in category: $category"
        return 0
    fi

    local installed=0
    local missing=()

    for package in "${packages[@]}"; do
        if pacman -Qi "$package" &> /dev/null; then
            print_success "✅ $package"
            ((installed++))
        else
            print_warning "❌ $package (not installed)"
            missing+=("$package")
        fi
    done

    echo -e "\n${BLUE}Summary for $description:${NC}"
    echo -e "  Installed: ${GREEN}$installed${NC}/${#packages[@]}"

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo -e "  Missing: ${RED}${#missing[@]}${NC}"
        echo -e "  Install with: ${YELLOW}sudo pacman -S ${missing[*]}${NC}"
    else
        echo -e "  ${GREEN}All packages installed!${NC}"
    fi

    return ${#missing[@]}
}

# Check specific config dependencies
check_config_deps() {
    echo -e "\n${BLUE}=== Configuration Dependencies ===${NC}"

    declare -A config_deps=(
        ["hypr"]="hyprland waybar wofi mako swaylock wlogout grim slurp"
        ["nvim"]="neovim"
        ["wezterm"]="wezterm"
        ["ghostty"]="ghostty"
        ["kitty"]="kitty"
        ["alacritty"]="alacritty"
        ["i3"]="i3-wm i3blocks i3status polybar picom"
        ["terminal"]="fish zsh starship zoxide eza bat ripgrep fd fzf"
    )

    local total_missing=0

    for config in "${!config_deps[@]}"; do
        if [[ -d "$SCRIPT_DIR/.config/$config" ]]; then
            echo -e "\n${YELLOW}Checking $config configuration:${NC}"
            local missing=()

            for package in ${config_deps[$config]}; do
                if pacman -Qi "$package" &> /dev/null; then
                    echo -e "  ✅ $package"
                else
                    echo -e "  ❌ $package"
                    missing+=("$package")
                fi
            done

            if [[ ${#missing[@]} -gt 0 ]]; then
                echo -e "  ${RED}Missing packages for $config: ${missing[*]}${NC}"
                echo -e "  ${YELLOW}Install with: sudo pacman -S ${missing[*]}${NC}"
                ((total_missing += ${#missing[@]}))
            else
                echo -e "  ${GREEN}All dependencies for $config are installed!${NC}"
            fi
        fi
    done

    return $total_missing
}

# Show system info
show_system_info() {
    echo -e "${BLUE}=== System Information ===${NC}"
    echo -e "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '\"')"
    echo -e "Kernel: $(uname -r)"
    echo -e "Package Manager: $(command -v pacman >/dev/null && echo "pacman" || echo "other")"
    echo -e "AUR Helper: $(command -v yay >/dev/null && echo "yay" || command -v paru >/dev/null && echo "paru" || echo "none")"
    echo -e "Dotfiles Path: $SCRIPT_DIR"
}

# Main function
main() {
    echo -e "${BLUE}🔍 Dotfiles Dependency Checker${NC}\n"

    show_system_info
    check_yq

    local total_issues=0

    # Check by categories
    check_category "core" "Core Packages"
    total_issues=$((total_issues + $?))

    check_category "terminal" "Terminal Tools"
    total_issues=$((total_issues + $?))

    check_category "terminal_emulators" "Terminal Emulators"
    total_issues=$((total_issues + $?))

    check_category "development" "Development Tools"
    total_issues=$((total_issues + $?))

    check_category "desktop" "Desktop Environment"
    total_issues=$((total_issues + $?))

    check_category "fonts" "Font Packages"
    total_issues=$((total_issues + $?))

    # Check config-specific dependencies
    check_config_deps
    total_issues=$((total_issues + $?))

    # Summary
    echo -e "\n${BLUE}=== Final Summary ===${NC}"
    if [[ $total_issues -eq 0 ]]; then
        print_success "🎉 All dependencies are satisfied!"
        echo -e "Your dotfiles should work perfectly."
    else
        print_warning "⚠️  Found $total_issues missing packages"
        echo -e "\n${YELLOW}Quick fixes:${NC}"
        echo -e "1. Install all missing packages: ${BLUE}./install.sh --all${NC}"
        echo -e "2. Install specific categories: ${BLUE}./install.sh core terminal desktop${NC}"
        echo -e "3. Install manually with the suggested pacman commands above"
    fi
}

# Show help
show_help() {
    cat << HELP_EOF
Dotfiles Dependency Checker

This script checks if all required packages are installed for your dotfiles.

Usage: $0 [OPTIONS]

OPTIONS:
    -h, --help          Show this help message
    --config-only       Check only configuration-specific dependencies
    --category CATEGORY Check only specific category (core, terminal, etc.)

Examples:
    $0                      # Check all dependencies
    $0 --config-only       # Check only config dependencies
    $0 --category core     # Check only core packages

HELP_EOF
}

# Parse arguments
if [[ $# -gt 0 ]]; then
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        --config-only)
            echo -e "${BLUE}🔍 Checking Configuration Dependencies Only${NC}\n"
            show_system_info
            check_yq
            check_config_deps
            exit $?
            ;;
        --category)
            if [[ -n "$2" ]]; then
                echo -e "${BLUE}🔍 Checking $2 Category${NC}\n"
                show_system_info
                check_yq
                check_category "$2" "$2 packages"
                exit $?
            else
                print_error "Category name required"
                show_help
                exit 1
            fi
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
fi

# Run main function
main