import json
import sys

# Define the battery level icons
battery_icons = {
    100: "󰂀",
    90: "󰂀",
    80: "󰂁",
    70: "󰂀",
    60: "󰁿",
    50: "󰁾",
    40: "󰁽",
    30: "󰁼",
    20: "󰁻",
    10: "󰁺",
    0: "󰁹",
}

# Read each line from the i3status output
for line in sys.stdin:
    # Check if the line is not empty and is valid JSON
    try:
        data = json.loads(line)
    except json.JSONDecodeError:
        continue

    # Find the battery block
    for block in data:
        if block['name'] == 'battery 0':
            # Get the current battery level
            battery_level = int(block['percentage'][:-1])
            print("Battery leve")
            print(battery_level)

            # Find the appropriate icon
            for level in sorted(battery_icons.keys(), reverse=True):
                if battery_level >= level:
                    block['full_text'] = battery_icons[level] + " " + block['full_text']
                    break

    # Output the modified line
    print(json.dumps(data))
