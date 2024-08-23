
#!/bin/bash

# Function to set the laptop screen as primary
set_laptop_primary() {
    xrandr --output eDP --primary --auto --output HDMI-A-0 --off
}

set_external_moniter_primary() {
    xrandr --output eDP --off --output HDMI-A-0 --primary --auto --scale 1.0x1.0
}

# Monitor the display state
while true; do
    # Check if the external monitor is connected
    if ! xrandr | grep -q "HDMI-1 connected"; then
        # External monitor is disconnected, set the laptop screen as primary
        set_laptop_primary
    fi

    if  xrandr | grep -q "HDMI-1 connected"; then
        # External monitor is disconnected, set the laptop screen as primary
        set_external_moniter_primary
    fi


    # Sleep for 2 seconds before checking again
    sleep 2
done
