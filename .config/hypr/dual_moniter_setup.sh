#!/bin/bash

restart_waybar() {
    pkill waybar
    waybar --config ~/.config/waybar/config.jsonc
}

# Function to set the laptop screen as primary
set_laptop_primary() {
  hyprctl keyword monitor eDP-1,preferred,auto,1 
  restart_waybar
}

set_external_monitor_primary() {
  swww img ~/wallpapers/creation.jpg --transition-fps 60 --transition-type wipe --transition-duration 1.2
  hyprctl keyword monitor eDP-1, disable
  restart_waybar
}

# Function to check the HDMI connection status
is_hdmi_connected() {
    hyprctl monitors | grep -q "HDMI-A-1"
}

# Function to monitor the display state
monitor_display_state() {
    # Variable to keep track of the current primary display
    local current_primary="eDP-1"

    while true; do
        if is_hdmi_connected && [ "$current_primary" = "eDP-1" ]; then
            set_external_monitor_primary
            current_primary="HDMI-A-1"
        elif ! is_hdmi_connected && [ "$current_primary" = "HDMI-A-1" ]; then
            set_laptop_primary
            current_primary="eDP-1"
        fi

        # Sleep for 2 seconds before checking again
        sleep 2
    done
}

trap "echo 'Exiting...'; exit" SIGINT SIGTERM
monitor_display_state
