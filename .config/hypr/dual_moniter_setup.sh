#!/bin/bash

# Configuration
WALLPAPER_PATH="${WALLPAPER_PATH:-$HOME/wallpapers/bigbrother.jpg}"
LOG_FILE="${LOG_FILE:-$HOME/.local/share/hypr/monitor.log}"
CHECK_INTERVAL="${CHECK_INTERVAL:-2}"

# Create log directory if it doesn't exist
mkdir -p "$(dirname "$LOG_FILE")"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Check dependencies
check_dependencies() {
    local missing_deps=()
    command -v hyprctl >/dev/null 2>&1 || missing_deps+=("hyprctl")
    command -v waybar >/dev/null 2>&1 || missing_deps+=("waybar")
    command -v swww >/dev/null 2>&1 || missing_deps+=("swww")

    if [ ${#missing_deps[@]} -ne 0 ]; then
        log "Error: Missing dependencies: ${missing_deps[*]}"
        exit 1
    fi
}

restart_waybar() {
    log "Restarting waybar..."
    pkill waybar
    waybar --config ~/.config/waybar/config.jsonc &
    sleep 1
    if ! pgrep -x "waybar" > /dev/null; then
        log "Error: Failed to restart waybar"
        return 1
    fi
    log "Waybar restarted successfully"
}

# Function to set the laptop screen as primary
set_laptop_primary() {
    log "Switching to laptop display..."
    if ! hyprctl keyword monitor eDP-1,preferred,auto,1; then
        log "Error: Failed to configure laptop display"
        return 1
    fi
    if ! hyprctl keyword monitor HDMI-A-1,disable; then
        log "Warning: Failed to disable HDMI display (might be already disabled)"
    fi
    if [ -f "$WALLPAPER_PATH" ]; then
        swww img "$WALLPAPER_PATH" --transition-fps 60 --transition-type wipe --transition-duration 1.2
    else
        log "Warning: Wallpaper not found at $WALLPAPER_PATH"
    fi
    restart_waybar
    log "Successfully switched to laptop display"
}

set_external_monitor_primary() {
    log "Switching to external display only..."

    # Try to force Hyprland to detect and configure the monitor
    log "Attempting to configure HDMI-A-1 monitor..."

    # First try to enable the monitor with preferred settings
    if ! hyprctl keyword monitor HDMI-A-1,preferred,auto,1; then
        log "Error: Failed to configure external display with preferred settings"
        # Try alternative configuration
        if ! hyprctl keyword monitor HDMI-A-1,1920x1080@60,0x0,1; then
            log "Error: Failed to configure external display with manual settings"
            return 1
        else
            log "Successfully configured external display with manual settings"
        fi
    else
        log "Successfully configured external display with preferred settings"
    fi

    # Wait a moment for the monitor to be recognized
    sleep 1

    # Disable laptop monitor
    if ! hyprctl keyword monitor eDP-1,disable; then
        log "Warning: Failed to disable laptop display (might be already disabled)"
    fi

    # Verify the monitor is actually active
    local monitor_count=$(hyprctl monitors | grep -c "Monitor")
    log "Active monitors after configuration: $monitor_count"

    if [ -f "$WALLPAPER_PATH" ]; then
        swww img "$WALLPAPER_PATH" --transition-fps 60 --transition-type wipe --transition-duration 1.2
    else
        log "Warning: Wallpaper not found at $WALLPAPER_PATH"
    fi
    restart_waybar
    log "Successfully switched to external display only"
}

# New function to set up dual monitor configuration
set_dual_monitor_setup() {
    log "Setting up dual monitor configuration (External left, Laptop right)..."
    if ! hyprctl keyword monitor HDMI-A-1,1920x1080@60,0x0,1; then
        log "Error: Failed to configure external display"
        return 1
    fi
    if ! hyprctl keyword monitor eDP-1,1920x1080@60.05,1920x0,1; then
        log "Error: Failed to configure laptop display"
        return 1
    fi
    if [ -f "$WALLPAPER_PATH" ]; then
        swww img "$WALLPAPER_PATH" --transition-fps 60 --transition-type wipe --transition-duration 1.2
    else
        log "Warning: Wallpaper not found at $WALLPAPER_PATH"
    fi
    restart_waybar
    log "Successfully set up dual monitor configuration"
}

# Function to check the HDMI connection status
is_hdmi_connected() {
    # Check system-level detection only (more reliable)
    local system_status=$(cat /sys/class/drm/card1-HDMI-A-1/status 2>/dev/null || echo "disconnected")

    if [ "$system_status" = "connected" ]; then
        return 0
    else
        return 1
    fi
}

# Function to get current display status
get_display_status() {
    echo "Current display configuration:"
    hyprctl monitors | grep -E "monitor|mapped|focused"
}

# Function to monitor the display state
monitor_display_state() {
    log "Starting display monitor..."
    local last_state=""
    local current_state=""

    while true; do
        # Get current state
        if is_hdmi_connected; then
            current_state="HDMI_CONNECTED"
        else
            current_state="HDMI_DISCONNECTED"
        fi

        # Only process if state has changed
        if [ "$current_state" != "$last_state" ]; then
            log "Display state changed: $current_state"

            if [ "$current_state" = "HDMI_CONNECTED" ]; then
                log "External monitor detected - switching to external display only"
                set_external_monitor_primary
            else
                log "External monitor disconnected - switching to laptop display only"
                set_laptop_primary
            fi

            last_state="$current_state"
        fi

        sleep "$CHECK_INTERVAL"
    done
}

# Show help message
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -s, --status   Show current display status"
    echo "  -l, --laptop   Switch to laptop display only"
    echo "  -e, --external Switch to external display only"
    echo "  -d, --dual     Set up dual monitor configuration (External left, Laptop right)"
    echo "  -w, --wallpaper PATH  Set custom wallpaper path"
    echo "  -i, --interval SECONDS Set check interval (default: 2)"
}

# Main script
check_dependencies

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -s|--status)
            get_display_status
            exit 0
            ;;
        -l|--laptop)
            set_laptop_primary
            exit 0
            ;;
        -e|--external)
            if is_hdmi_connected; then
                set_external_monitor_primary
            else
                log "Error: External display not connected"
            fi
            exit 0
            ;;
        -d|--dual)
            if is_hdmi_connected; then
                set_dual_monitor_setup
            else
                log "Error: External display not connected - cannot set up dual monitor configuration"
            fi
            exit 0
            ;;
        -w|--wallpaper)
            WALLPAPER_PATH="$2"
            shift
            ;;
        -i|--interval)
            CHECK_INTERVAL="$2"
            shift
            ;;
        *)
            log "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
    shift
done

# Set up trap for clean exit
trap 'log "Exiting..."; exit' SIGINT SIGTERM

# Start monitoring
monitor_display_state
