#!/bin/bash

# Dotfiles Sync Script
# This script automatically syncs configuration files from ~/.config to ~/.dotfiles/.config
# and manages symlinks using GNU Stow

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory (should be ~/.dotfiles)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"
SYSTEM_CONFIG_DIR="$HOME/.config"
DOTFILES_CONFIG_DIR="$DOTFILES_DIR/.config"

# Function to print colored output
print_status() {
    [[ "$QUIET" == "true" ]] && return
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    [[ "$QUIET" == "true" ]] && return
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_verbose() {
    [[ "$VERBOSE" == "true" ]] && echo -e "${BLUE}[VERBOSE]${NC} $1"
}

# Function to create backup of files before sync
create_backup() {
    local file="$1"
    local backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"
    local rel_path="${file#$HOME/.config/}"
    local backup_file="$backup_dir/$rel_path"

    mkdir -p "$(dirname "$backup_file")"
    cp -p "$file" "$backup_file"
    print_verbose "Backed up: $rel_path"
}

# Function to check if a file should be ignored
should_ignore() {
    local file="$1"
    local ignore_patterns=(
        ".git"
        ".gitignore"
        "*.tmp"
        "*.swp"
        "*.bak"
        "*~"
        ".DS_Store"
        "Thumbs.db"
        "*.log"
        "*.cache"
        "node_modules"
        "__pycache__"
        ".pytest_cache"
        ".mypy_cache"
        "*.pyc"
        "*.pyo"
    )
    
    for pattern in "${ignore_patterns[@]}"; do
        if [[ "$file" == $pattern ]]; then
            return 0
        fi
    done
    return 1
}

# Function to sync a single config directory
sync_config_dir() {
    local config_name="$1"
    local system_dir="$SYSTEM_CONFIG_DIR/$config_name"
    local dotfiles_dir="$DOTFILES_CONFIG_DIR/$config_name"
    
    if [[ ! -d "$system_dir" ]]; then
        print_warning "System directory $system_dir does not exist, skipping..."
        return 0
    fi
    
    print_status "Syncing $config_name..."
    
    # Create dotfiles directory if it doesn't exist
    mkdir -p "$dotfiles_dir"
    
    # Find files that exist in system but not in dotfiles (or are different)
    local files_to_sync=()
    
    # Use find to get all files in system directory
    while IFS= read -r -d '' file; do
        local rel_path="${file#$system_dir/}"
        local dotfiles_file="$dotfiles_dir/$rel_path"
        
        # Skip if should be ignored
        if should_ignore "$(basename "$file")"; then
            continue
        fi
        
        # Check if file doesn't exist in dotfiles or is different
        if [[ ! -e "$dotfiles_file" ]] || ! cmp -s "$file" "$dotfiles_file"; then
            # Skip if it's already a symlink pointing to dotfiles
            if [[ -L "$file" ]] && [[ "$(readlink "$file")" == *".dotfiles"* ]]; then
                continue
            fi
            files_to_sync+=("$file")
        fi
    done < <(find "$system_dir" -type f -print0)
    
    if [[ ${#files_to_sync[@]} -eq 0 ]]; then
        print_success "No new files to sync for $config_name"
        return 0
    fi
    
    print_status "Found ${#files_to_sync[@]} files to sync for $config_name"
    
    # Copy files to dotfiles directory
    for file in "${files_to_sync[@]}"; do
        local rel_path="${file#$system_dir/}"
        local dotfiles_file="$dotfiles_dir/$rel_path"
        local dotfiles_file_dir="$(dirname "$dotfiles_file")"
        
        # Create backup of important files
        if [[ "$VERBOSE" == "true" ]]; then
            create_backup "$file"
        fi

        # Create directory structure if needed
        mkdir -p "$dotfiles_file_dir"

        # Copy file maintaining permissions
        cp -p "$file" "$dotfiles_file"
        print_verbose "Copied: $rel_path"
        [[ "$QUIET" != "true" ]] && print_status "Copied: $rel_path"
    done
    
    # Remove original files (they will be replaced by symlinks)
    for file in "${files_to_sync[@]}"; do
        if [[ ! -L "$file" ]]; then  # Only remove if it's not already a symlink
            rm "$file"
            print_verbose "Removed original: ${file#$system_dir/}"
        fi
    done
    
    print_success "Synced $config_name successfully"
}

# Function to run stow
run_stow() {
    print_status "Running stow to create symlinks..."
    cd "$DOTFILES_DIR"

    # Run stow with appropriate verbosity
    if [[ "$VERBOSE" == "true" ]]; then
        if stow -v .; then
            print_success "Stow completed successfully"
        else
            print_error "Stow failed, there might be conflicts"
            print_error "Try running: stow -v . manually to see details"
            return 1
        fi
    elif [[ "$QUIET" == "true" ]]; then
        if stow . >/dev/null 2>&1; then
            print_success "Stow completed successfully"
        else
            print_error "Stow failed, there might be conflicts"
            return 1
        fi
    else
        if stow . 2>/dev/null; then
            print_success "Stow completed successfully"
        else
            print_error "Stow failed, there might be conflicts"
            print_error "Run with -v for detailed output"
            return 1
        fi
    fi
}

# Function to show git status (no auto-commit)
show_git_status() {
    cd "$DOTFILES_DIR"

    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        print_warning "Not in a git repository - skipping git status"
        return 0
    fi

    if [[ -n "$(git status --porcelain)" ]]; then
        [[ "$QUIET" != "true" ]] && print_status "Git changes detected:"
        [[ "$QUIET" != "true" ]] && git status --short
        [[ "$QUIET" != "true" ]] && echo
        print_warning "📝 Changes are ready to be committed manually when you're ready."
        [[ "$QUIET" != "true" ]] && print_status "💡 To commit: git add . && git commit -m 'your message'"
        [[ "$QUIET" != "true" ]] && print_status "🚀 To push: git push origin main"
    else
        print_success "✅ No git changes detected"
    fi
}

# Function to show help
show_help() {
    cat << HELP_EOF
Dotfiles Sync Script

Usage: $0 [OPTIONS] [CONFIG_NAMES...]

OPTIONS:
    -h, --help          Show this help message
    -n, --dry-run       Show what would be done without making changes
    -s, --skip-stow     Skip running stow (useful for manual stow management)
    -q, --quiet         Suppress non-essential output
    -v, --verbose       Show detailed output
    
CONFIG_NAMES:
    Specific configuration directories to sync (e.g., hypr, nvim, kitty)
    If not specified, all directories in .dotfiles/.config will be processed

Examples:
    $0                  # Sync all config directories
    $0 hypr nvim        # Sync only hypr and nvim
    $0 -n               # Dry run - show what would be synced
    $0 -q hypr          # Quietly sync only hypr config
    $0 -v               # Verbose sync of all configs
    
HELP_EOF
}

# Parse command line arguments
DRY_RUN=false
SKIP_STOW=false
QUIET=false
VERBOSE=false
CONFIG_DIRS=()

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -n|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -s|--skip-stow)
            SKIP_STOW=true
            shift
            ;;
        -q|--quiet)
            QUIET=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -*)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
        *)
            CONFIG_DIRS+=("$1")
            shift
            ;;
    esac
done

# Main execution
main() {
    print_status "Starting dotfiles sync..."
    print_status "Dotfiles directory: $DOTFILES_DIR"
    print_status "System config directory: $SYSTEM_CONFIG_DIR"
    
    # Check if we're in the right directory
    if [[ ! -d "$DOTFILES_CONFIG_DIR" ]]; then
        print_error "Cannot find .config directory in $DOTFILES_DIR"
        print_error "Make sure you're running this script from your dotfiles directory"
        exit 1
    fi
    
    # Check if stow is installed
    if ! command -v stow &> /dev/null && [[ "$SKIP_STOW" != "true" ]]; then
        print_error "GNU Stow is not installed. Please install it first."
        exit 1
    fi
    
    # Determine which config directories to process
    local dirs_to_process=()
    
    if [[ ${#CONFIG_DIRS[@]} -gt 0 ]]; then
        # Use specified directories
        dirs_to_process=("${CONFIG_DIRS[@]}")
    else
        # Use all directories in .dotfiles/.config
        for dir in "$DOTFILES_CONFIG_DIR"/*; do
            if [[ -d "$dir" ]]; then
                dirs_to_process+=("$(basename "$dir")")
            fi
        done
    fi
    
    if [[ ${#dirs_to_process[@]} -eq 0 ]]; then
        print_warning "No configuration directories found to process"
        exit 0
    fi
    
    print_status "Processing directories: ${dirs_to_process[*]}"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        print_warning "DRY RUN MODE - No changes will be made"
        # Show what would be done
        for config_dir in "${dirs_to_process[@]}"; do
            local system_dir="$SYSTEM_CONFIG_DIR/$config_dir"
            local dotfiles_dir="$DOTFILES_CONFIG_DIR/$config_dir"
            
            if [[ ! -d "$system_dir" ]]; then
                print_warning "System directory $system_dir does not exist, would skip..."
                continue
            fi
            
            print_status "Would sync $config_dir..."
            
            # Find files that would be synced
            while IFS= read -r -d '' file; do
                local rel_path="${file#$system_dir/}"
                local dotfiles_file="$dotfiles_dir/$rel_path"
                
                if should_ignore "$(basename "$file")"; then
                    continue
                fi
                
                if [[ ! -e "$dotfiles_file" ]] || ! cmp -s "$file" "$dotfiles_file"; then
                    if [[ -L "$file" ]] && [[ "$(readlink "$file")" == *".dotfiles"* ]]; then
                        continue
                    fi
                    print_status "Would copy: $rel_path"
                fi
            done < <(find "$system_dir" -type f -print0 2>/dev/null)
        done
        exit 0
    fi
    
    # Sync each configuration directory
    for config_dir in "${dirs_to_process[@]}"; do
        sync_config_dir "$config_dir"
    done
    
    # Run stow if not skipped
    if [[ "$SKIP_STOW" != "true" ]]; then
        run_stow
    fi
    
    # Show git status (no auto-commit)
    show_git_status
    
    print_success "Dotfiles sync completed successfully!"
}

# Run main function
main "$@"
