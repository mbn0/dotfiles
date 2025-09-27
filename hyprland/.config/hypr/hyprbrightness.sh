#!/usr/bin/env bash
direction=$1   # should be + or -

# Do not run this script with sudo, it will fail to get the monitor name.
# The ddcutil command will use sudo itself.

focused_name=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

if [ -z "$focused_name" ]; then
    echo "Could not get focused monitor name from hyprctl."
    # Attempt to get hyprctl output for debugging
    hyprctl monitors -j
    exit 1
fi

if [ "$focused_name" = "eDP-1" ]; then
    # Internal display: use brightnessctl
    brightnessctl s 8%${direction}
elif [ "$focused_name" = "HDMI-A-1" ]; then
    # External ASUS monitor: use ddcutil (replace 1 with actual display number)
    # This command needs root, so we use sudo.
    sudo ddcutil --display=1 setvcp 10 ${direction} 8
else
    echo "Unknown monitor: $focused_name"
fi