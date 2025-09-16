# Dotfiles Sync Script Guide

## Overview

The `sync-dotfiles.sh` script automates the process of syncing configuration files from your system's `~/.config` directory to your dotfiles repository and managing symlinks with GNU Stow.

## Features

- ✅ **Automatic Detection**: Finds new or modified config files in your system
- ✅ **Safe Syncing**: Only copies files that are different or missing
- ✅ **Symlink Management**: Uses GNU Stow to create and manage symlinks
- ✅ **Git Status Display**: Shows git changes without auto-committing (safer approach)
- ✅ **Selective Sync**: Sync specific config directories or all at once
- ✅ **Dry Run Mode**: Preview what would be done without making changes
- ✅ **Multiple Output Modes**: Quiet, normal, and verbose modes
- ✅ **Automatic Backups**: Creates backups in verbose mode for safety
- ✅ **Enhanced Safety**: Extended ignore patterns and better error handling
- ✅ **Colored Output**: Clear, colored status messages with emojis

## Usage

### Basic Usage

```bash
# Sync all configuration directories
./sync-dotfiles.sh

# Sync specific directories only
./sync-dotfiles.sh hypr nvim kitty

# Preview what would be synced (dry run)
./sync-dotfiles.sh -n

# Quiet sync with minimal output
./sync-dotfiles.sh -q

# Verbose sync with backups and detailed output
./sync-dotfiles.sh -v
```

### Command Options

| Option | Description |
|--------|-------------|
| `-h, --help` | Show help message |
| `-n, --dry-run` | Show what would be done without making changes |
| `-q, --quiet` | Suppress non-essential output |
| `-v, --verbose` | Show detailed output and create backups |
| `-s, --skip-stow` | Skip running stow (useful for manual stow management) |

### Examples

```bash
# Sync all config directories with detailed output and backups
./sync-dotfiles.sh -v

# Quietly sync only hypr and nvim configs
./sync-dotfiles.sh -q hypr nvim

# Preview what would be synced for all directories
./sync-dotfiles.sh -n

# Sync everything but skip stow (manual symlink management)
./sync-dotfiles.sh -s

# Verbose sync of specific config with full safety features
./sync-dotfiles.sh -v ghostty wezterm
```

## How It Works

1. **Detection**: The script scans your `~/.config` directories for files that:
   - Don't exist in your dotfiles directory
   - Are different from files in your dotfiles directory
   - Are not already symlinked to your dotfiles

2. **Sync Process**: For each detected file:
   - Copy the file to your dotfiles directory (maintaining permissions)
   - Remove the original file from your system
   - Let GNU Stow create a symlink back to the dotfiles version

3. **Git Status Display**: After syncing:
   - Shows current git status with colorful output
   - Displays what files have changed
   - Provides helpful commands for manual commit and push
   - **No automatic commits** for safety

## File Ignore Patterns

The script automatically ignores certain files:
- **Git files**: `.git`, `.gitignore`
- **Temporary files**: `*.tmp`, `*.swp`, `*.bak`, `*~`
- **System files**: `.DS_Store`, `Thumbs.db`
- **Log files**: `*.log`, `*.cache`
- **Development artifacts**: `node_modules`, `__pycache__`, `.pytest_cache`, `.mypy_cache`
- **Python bytecode**: `*.pyc`, `*.pyo`

## Safety Features

- **No Auto-Commit**: Manual control over git commits prevents accidental broken states
- **Automatic Backups**: In verbose mode, creates timestamped backups in `~/.dotfiles-backup/`
- **Symlink Detection**: Won't touch files that are already symlinked to dotfiles
- **Directory Validation**: Ensures dotfiles directory structure exists
- **Enhanced Error Handling**: Detailed error messages with suggestions
- **Git Repository Validation**: Checks if you're in a git repo before operations
- **Dry Run Mode**: Test what would happen before making changes
- **Extended Ignore Patterns**: Prevents syncing of temporary and build files

## Typical Workflow

1. **Add new config files** to your system (e.g., `~/.config/hypr/new-script.sh`)
2. **Run the sync script**: `./sync-dotfiles.sh` (or with `-v` for backups)
3. **Review the changes**: Script shows what it's doing with colored output
4. **Check git status**: Script displays git changes with helpful emoji indicators
5. **Manual commit**: Use the suggested commands to commit when ready
   ```bash
   git add .
   git commit -m "Add new hypr configuration"
   git push origin main
   ```

## Output Modes

### Normal Mode (Default)
```bash
./sync-dotfiles.sh
```
- Shows essential information and progress
- Displays git status with helpful commands
- Balanced verbosity for most users

### Quiet Mode (`-q`)
```bash
./sync-dotfiles.sh -q
```
- Minimal output, only errors and warnings
- Perfect for scripts or when you want minimal noise
- Still shows important git status

### Verbose Mode (`-v`)
```bash
./sync-dotfiles.sh -v
```
- Detailed output showing every operation
- **Creates automatic backups** of changed files
- Shows backup locations and stow details
- Best for debugging or when you want full visibility

## Requirements

- GNU Stow (install with your package manager)
- Git repository initialized in your dotfiles directory
- Bash shell (version 4.0+)

That's it! The script handles the rest automatically. 🚀
