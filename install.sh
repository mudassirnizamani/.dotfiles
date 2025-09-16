#!/bin/bash

# Dotfiles Installation Script with Dependency Management
# This script installs packages and sets up your dotfiles environment

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_FILE="$SCRIPT_DIR/packages.yml"

# Print functions
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

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Arch/Manjaro
check_arch() {
    if ! command -v pacman &> /dev/null; then
        print_error "This script is designed for Arch Linux/Manjaro systems"
        print_error "Please adapt the package manager commands for your distribution"
        exit 1
    fi
}

# Check if yq is available for YAML parsing
ensure_yq() {
    if ! command -v yq &> /dev/null; then
        print_status "Installing yq for YAML parsing..."
        sudo pacman -S --noconfirm yq
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

# Install AUR helper if not present
install_aur_helper() {
    if command -v yay &> /dev/null; then
        print_success "yay is already installed"
        return 0
    elif command -v paru &> /dev/null; then
        print_success "paru is already installed"
        return 0
    fi

    print_status "Installing yay AUR helper..."

    # Install dependencies
    sudo pacman -S --needed --noconfirm base-devel git

    # Clone and build yay
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd "$SCRIPT_DIR"

    print_success "yay installed successfully"
}

# Install packages from a category
install_packages() {
    local category="$1"
    local description="$2"
    local use_aur="$3"

    print_header "Installing $description"

    local packages=($(parse_packages "$category"))

    if [[ ${#packages[@]} -eq 0 ]]; then
        print_warning "No packages found in category: $category"
        return 0
    fi

    print_status "Found ${#packages[@]} packages in $category"

    # Filter out already installed packages
    local to_install=()
    for package in "${packages[@]}"; do
        if ! pacman -Qi "$package" &> /dev/null; then
            to_install+=("$package")
        else
            print_status "$package is already installed"
        fi
    done

    if [[ ${#to_install[@]} -eq 0 ]]; then
        print_success "All $description packages are already installed"
        return 0
    fi

    print_status "Installing ${#to_install[@]} new packages..."

    if [[ "$use_aur" == "true" ]]; then
        # Use AUR helper
        if command -v yay &> /dev/null; then
            yay -S --noconfirm "${to_install[@]}"
        elif command -v paru &> /dev/null; then
            paru -S --noconfirm "${to_install[@]}"
        else
            print_error "No AUR helper found for AUR packages"
            return 1
        fi
    else
        # Use pacman
        sudo pacman -S --noconfirm "${to_install[@]}"
    fi

    print_success "$description packages installed"
}

# Setup dotfiles with stow
setup_dotfiles() {
    print_header "Setting up dotfiles with Stow"

    if [[ ! -d "$SCRIPT_DIR/.config" ]]; then
        print_error "No .config directory found in dotfiles"
        return 1
    fi

    print_status "Creating symlinks with stow..."
    cd "$SCRIPT_DIR"

    if stow -v .; then
        print_success "Dotfiles linked successfully"
    else
        print_error "Stow failed - there might be conflicts"
        print_status "You may need to backup existing config files"
        return 1
    fi
}

# Setup shell (fish as default)
setup_shell() {
    print_header "Setting up shell"

    if command -v fish &> /dev/null; then
        local fish_path=$(which fish)

        # Add fish to /etc/shells if not present
        if ! grep -q "$fish_path" /etc/shells; then
            print_status "Adding fish to /etc/shells..."
            echo "$fish_path" | sudo tee -a /etc/shells
        fi

        # Change default shell to fish
        if [[ "$SHELL" != "$fish_path" ]]; then
            print_status "Changing default shell to fish..."
            chsh -s "$fish_path"
            print_success "Default shell changed to fish (will take effect on next login)"
        else
            print_success "Fish is already the default shell"
        fi
    else
        print_warning "Fish shell not installed, skipping shell setup"
    fi
}

# Setup services
setup_services() {
    print_header "Setting up system services"

    # Enable NetworkManager
    if systemctl list-unit-files | grep -q NetworkManager.service; then
        sudo systemctl enable --now NetworkManager
        print_success "NetworkManager enabled"
    fi

    # Enable bluetooth
    if systemctl list-unit-files | grep -q bluetooth.service; then
        sudo systemctl enable --now bluetooth
        print_success "Bluetooth enabled"
    fi

    # Setup auto-cpufreq if config exists
    if [[ -f "$SCRIPT_DIR/auto-cpufreq.conf" ]] && command -v auto-cpufreq &> /dev/null; then
        print_status "Setting up auto-cpufreq..."
        sudo cp "$SCRIPT_DIR/auto-cpufreq.conf" /etc/auto-cpufreq.conf
        sudo systemctl enable --now auto-cpufreq
        print_success "auto-cpufreq configured and enabled"
    fi
}

# Show help
show_help() {
    cat << HELP_EOF
Dotfiles Installation Script

Usage: $0 [OPTIONS] [CATEGORIES...]

OPTIONS:
    -h, --help          Show this help message
    -a, --all           Install all package categories
    -c, --core-only     Install only core packages
    -d, --desktop       Install desktop environment packages
    -s, --skip-aur      Skip AUR packages
    --no-stow           Skip dotfiles setup with stow
    --no-shell          Skip shell setup
    --no-services       Skip service setup

CATEGORIES:
    core                Core system packages
    terminal            Terminal and shell tools
    terminal_emulators  Terminal emulators
    development         Development tools
    desktop             Window manager and desktop
    fonts               Font packages
    media               Media and graphics tools
    utilities           System utilities
    optional            Optional packages
    aur                 AUR packages
    languages           Programming languages
    gaming              Gaming packages

Examples:
    $0 --all                    # Install everything
    $0 --core-only             # Install only core packages
    $0 core terminal desktop   # Install specific categories
    $0 --skip-aur core desktop # Install without AUR packages

HELP_EOF
}

# Parse command line arguments
INSTALL_ALL=false
CORE_ONLY=false
DESKTOP_ONLY=false
SKIP_AUR=false
NO_STOW=false
NO_SHELL=false
NO_SERVICES=false
CATEGORIES=()

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -a|--all)
            INSTALL_ALL=true
            shift
            ;;
        -c|--core-only)
            CORE_ONLY=true
            shift
            ;;
        -d|--desktop)
            DESKTOP_ONLY=true
            shift
            ;;
        -s|--skip-aur)
            SKIP_AUR=true
            shift
            ;;
        --no-stow)
            NO_STOW=true
            shift
            ;;
        --no-shell)
            NO_SHELL=true
            shift
            ;;
        --no-services)
            NO_SERVICES=true
            shift
            ;;
        -*)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
        *)
            CATEGORIES+=("$1")
            shift
            ;;
    esac
done

# Main execution
main() {
    print_header "Dotfiles Installation Script"
    print_status "Starting installation process..."

    # Check prerequisites
    check_arch
    ensure_yq

    # Update system
    print_status "Updating system packages..."
    sudo pacman -Syu --noconfirm

    # Install AUR helper if needed
    if [[ "$SKIP_AUR" != "true" ]]; then
        install_aur_helper
    fi

    # Determine what to install
    if [[ "$INSTALL_ALL" == "true" ]]; then
        CATEGORIES=(core terminal terminal_emulators development desktop fonts media utilities)
        if [[ "$SKIP_AUR" != "true" ]]; then
            CATEGORIES+=(aur)
        fi
    elif [[ "$CORE_ONLY" == "true" ]]; then
        CATEGORIES=(core terminal)
    elif [[ "$DESKTOP_ONLY" == "true" ]]; then
        CATEGORIES=(core desktop fonts)
    elif [[ ${#CATEGORIES[@]} -eq 0 ]]; then
        # Default installation
        CATEGORIES=(core terminal terminal_emulators development desktop fonts)
    fi

    # Install packages by category
    for category in "${CATEGORIES[@]}"; do
        case $category in
            aur)
                if [[ "$SKIP_AUR" != "true" ]]; then
                    install_packages "aur" "AUR packages" "true"
                fi
                ;;
            *)
                install_packages "$category" "$category packages" "false"
                ;;
        esac
    done

    # Setup dotfiles
    if [[ "$NO_STOW" != "true" ]]; then
        setup_dotfiles
    fi

    # Setup shell
    if [[ "$NO_SHELL" != "true" ]]; then
        setup_shell
    fi

    # Setup services
    if [[ "$NO_SERVICES" != "true" ]]; then
        setup_services
    fi

    print_header "Installation Complete!"
    print_success "✅ All packages installed successfully"
    print_success "✅ Dotfiles configured with stow"
    print_success "✅ System services enabled"

    echo -e "\n${YELLOW}Next steps:${NC}"
    echo "1. Restart your terminal or run: exec \$SHELL"
    echo "2. Configure your window manager (Hyprland/i3)"
    echo "3. Customize your configs as needed"
    echo "4. Run: ./sync-dotfiles.sh to sync any future changes"

    if [[ "$NO_SHELL" != "true" ]] && command -v fish &> /dev/null; then
        echo "5. Your default shell has been changed to fish (requires logout/login)"
    fi
}

# Run main function
main "$@"