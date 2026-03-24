#!/bin/bash
swww init
WALLPAPER=$(find ~/Imagenes/Wallpapers -type f | shuf -n 1)
swww img "$WALLPAPER" --resize crop --transition-type outer --transition-step 90
wal -i "$WALLPAPER"
