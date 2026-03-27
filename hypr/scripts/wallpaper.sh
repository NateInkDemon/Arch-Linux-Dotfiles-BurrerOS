#!/bin/bash

if ! pgrep -x "awww-daemon" > /dev/null; then
    awww-daemon &
    sleep 0.8
fi

WALLPAPER=$(find ~/Wallpapers -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | shuf -n 1)

if [ -f "$WALLPAPER" ]; then
    awww img "$WALLPAPER" --resize crop --transition-type outer --transition-step 60

    wal -i "$WALLPAPER" -n -q
else
    echo "Error: No hay wallpapers en ~/Wallpapers"
fi
