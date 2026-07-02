#!/bin/bash
dir_wallpaper="$HOME/Pictures/Wallpapers"
hypr_colors="$HOME/.config/hypr/config/colors.lua"
wal_colors="$HOME/.cache/wal/colors.lua"

# Select wallpaper with rofi
selected=$(find "$dir_wallpaper" -type f | while read -r line; do 
    echo -e "$(basename "$line")\x00icon\x1f$line"; 
done | rofi -dmenu -theme ~/.config/rofi/wallpaper.rasi)

[ -z "$selected" ] && exit 0

wallpaper=$(find "$dir_wallpaper" -name "$selected" | head -n 1)

# Apply wallpaper with transition
awww img "$wallpaper" --transition-type grow --transition-duration 1

# Generate colors via wpgtk (updates oomox, pywal and our Kvantum templates)
wpg -s "$wallpaper"

# Wlogout replaces SVG fill colors with dynamic wal colors
COLOR_WAL=$(grep -oP '"color15": "\K[^"]+' ~/.cache/wal/colors.json)
find ~/.config/wlogout/assets/ -name "*.svg" -exec sed -i "s/fill=\"#[0-9a-fA-F]\{6\}\"/fill=\"$COLOR_WAL\"/g" {} +

# Hyprland Config colors
cp "$wal_colors" "$hypr_colors"

# Refresh Apps
pkill waybar; waybar & disown
pkill swaync; swaync
hyprctl reload

notify-send "🎨 Theme Updated" "$(basename "$wallpaper")"
