#!/bin/bash

# Define the battery level icons
declare -A battery_icons
battery_icons=(
    [100]="󰂀"
    [90]="󰂀"
    [80]="󰂁"
    [70]="󰂀"
    [60]="󰁿"
    [50]="󰁾"
    [40]="󰁽"
    [30]="󰁼"
    [20]="󰁻"
    [10]="󰁺"
    [0]="󰁹"
)

# Read each line from the i3status output
while read -r line; do
    # Parse the JSON
    battery_level=$(echo "$line" | jq -r '.[] | select(.name=="battery 0") | .percentage' | cut -d'%' -f1)

    # Find the appropriate icon
    for level in "${!battery_icons[@]}"; do
        if (( battery_level >= level )); then
            icon=${battery_icons[$level]}
            break
        fi
    done

    # Replace the battery icon in the JSON
    modified_line=$(echo "$line" | jq --arg icon "$icon" '.[] | select(.name=="battery 0") | .full_text = $icon + " " + .full_text')

    # Output the modified line
    echo "$modified_line"
done
