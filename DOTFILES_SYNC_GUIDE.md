# Dotfiles Sync Script Guide

## Overview

The `sync-dotfiles.sh` script automates the process of syncing configuration files from your system's `~/.config` directory to your dotfiles repository and managing symlinks with GNU Stow.

## Features

- ✅ **Automatic Detection**: Finds new or modified config files in your system
- ✅ **Safe Syncing**: Only copies files that are different or missing
- ✅ **Symlink Management**: Uses GNU Stow to create and manage symlinks
- ✅ **Git Integration**: Automatically commits changes to your dotfiles repository
- ✅ **Selective Sync**: Sync specific config directories or all at once
- ✅ **Dry Run Mode**: Preview what would be done without making changes
- ✅ **Colored Output**: Clear, colored status messages

## Usage

### Basic Usage

```bash
# Sync all configuration directories
./sync-dotfiles.sh

# Sync specific directories only
./sync-dotfiles.sh hypr nvim kitty

# Preview what would be synced (dry run)
./sync-dotfiles.sh -n

# Sync with auto-push to remote git repository
./sync-dotfiles.sh -a
```

### Command Options

| Option | Description |
|--------|-------------|
| `-h, --help` | Show help message |
| `-n, --dry-run` | Show what would be done without making changes |
| `-a, --auto-push` | Automatically push changes to git remote |
| `-s, --skip-stow` | Skip running stow (useful for manual stow management) |
| `-g, --skip-git` | Skip git operations |

### Examples

```bash
# Sync all config directories and auto-push to GitHub
./sync-dotfiles.sh -a

# Sync only hypr and nvim configs, skip git operations
./sync-dotfiles.sh -g hypr nvim

# Preview what would be synced for all directories
./sync-dotfiles.sh -n

# Sync everything but skip stow (manual symlink management)
./sync-dotfiles.sh -s
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

3. **Git Integration**: After syncing:
   - Add all new files to git
   - Commit with a timestamped message
   - Optionally push to remote repository

## File Ignore Patterns

The script automatically ignores certain files:
- `.git`, `.gitignore`
- Temporary files: `*.tmp`, `*.swp`, `*.bak`, `*~`
- System files: `.DS_Store`, `Thumbs.db`

## Safety Features

- **Symlink Detection**: Won't touch files that are already symlinked to dotfiles
- **Directory Validation**: Ensures dotfiles directory structure exists
- **Error Handling**: Exits safely if critical tools (stow, git) are missing
- **Dry Run Mode**: Test what would happen before making changes

## Typical Workflow

1. **Add new config files** to your system (e.g., `~/.config/hypr/new-script.sh`)
2. **Run the sync script**: `./sync-dotfiles.sh`
3. **Review the changes**: Script shows what it's doing with colored output
4. **Automatic git commit**: Changes are committed with timestamp
5. **Optional push**: Push to remote repository when prompted

## Requirements

- GNU Stow (install with your package manager)
- Git repository initialized in your dotfiles directory
- Bash shell (version 4.0+)

That's it! The script handles the rest automatically. 🚀
