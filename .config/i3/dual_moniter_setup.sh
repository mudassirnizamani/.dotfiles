
#!/bin/bash

# # Function to set the laptop screen as primary
# set_laptop_primary() {
#     xrandr --output eDP --primary --auto --output HDMI-A-0 --off
# }
#
# set_external_moniter_primary() {
#     xrandr --output eDP --off --output HDMI-A-0 --primary --auto --scale 1.0x1.0
# }
#
# # Monitor the display state
# while true; do
#     # Check if the external monitor is connected
#     if ! xrandr | grep -q "HDMI-A-0 disconnected"; then
#         # External monitor is disconnected, set the laptop screen as primary
#         set_laptop_primary
#     fi
#
#     if  xrandr | grep -q "HDMI-A-0 connected"; then
#         # External monitor is disconnected, set the laptop screen as primary
#         set_external_moniter_primary
#     fi
#
#
#     # Sleep for 2 seconds before checking again
#     sleep 2
# done

# Function to set the laptop screen as primary
set_laptop_primary() {
    xrandr --output eDP --primary --auto --output HDMI-A-0 --off
    feh --bg-fill ~/wallpapers/tony-stark.png
}

set_external_monitor_primary() {
    xrandr --output eDP --off --output HDMI-A-0 --primary --auto --scale 1.0x1.0
    feh --bg-fill ~/wallpapers/tony-stark.png
}

# Function to check the HDMI connection status
is_hdmi_connected() {
    xrandr | grep -q "HDMI-A-0 connected"
}

# Function to monitor the display state
monitor_display_state() {
    # Variable to keep track of the current primary display
    local current_primary="eDP"

    while true; do
        if is_hdmi_connected && [ "$current_primary" = "eDP" ]; then
            set_external_monitor_primary
            current_primary="HDMI-A-0"
        elif ! is_hdmi_connected && [ "$current_primary" = "HDMI-A-0" ]; then
            set_laptop_primary
            current_primary="eDP"
        fi

        # Sleep for 2 seconds before checking again
        sleep 2
    done
}

# Start monitoring the display state
monitor_display_state
