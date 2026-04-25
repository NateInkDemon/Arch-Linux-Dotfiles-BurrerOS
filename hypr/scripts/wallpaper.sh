#!/bin/bash

if ! pgrep -x "awww-daemon" > /dev/null; then
    swww-daemon &
    sleep 0.8
fi

TRANSITIONS=("outer" "grow" "center" "wipe" "circular" "wave" "any")

RAND_ANIM=${TRANSITIONS[$RANDOM % ${#TRANSITIONS[@]}]}

WALLPAPER=$(find ~/Wallpapers -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | shuf -n 1)

if [ -f "$WALLPAPER" ]; then
    awww img "$WALLPAPER" --transition-type "$RAND_ANIM" --transition-step 90 --transition-fps 75

    wal -i "$WALLPAPER" -n -q

    if [ -f "$HOME/.cache/wal/wob.ini" ]; then
        cp "$HOME/.cache/wal/wob.ini" "$HOME/.config/wob/wob.ini"
    fi

    pkill wob
    (tail -f $XDG_RUNTIME_DIR/wob.fifo | wob) &

    killall -SIGUSR2 waybar
    swaync-client -rs

    echo "Wallpaper [$RAND_ANIM]: $(basename "$WALLPAPER")"
else
    echo "Error: No encontré imágenes en ~/Wallpapers"
    exit 1
fi
