#!/usr/bin/env bash

if pidof rofi > /dev/null; then
    pkill rofi
fi

wallpapers_dir="$HOME/Wallpapers"

transitions=("outer" "grow" "center" "wipe" "circular" "wave" "pixel" "any")
rand_anim=${transitions[$RANDOM % ${#transitions[@]}]}

selected_wallpaper=$(for a in "$wallpapers_dir"/*; do
    echo -en "$(basename "${a%.*}")\0icon\x1f$a\n"
done | rofi -dmenu -p " " \
    -theme-str '
    @import "~/.cache/wal/colors-rofi-dark.rasi"

    * {
        bg-base: rgba(15, 17, 20, 0.85);
        accent-alt: @selected-normal-background;
        font: "JetBrainsMono Nerd Font 11";
        background-color: transparent;
        text-color: @foreground;
    }

    window {
        width: 75%;
        height: 70%;
        background-color: @bg-base;
        border: 2px;
        border-color: @accent-alt;
        border-radius: 15px;
        location: center;
        anchor: center;
    }

    listview {
        columns: 3;
        lines: 2;
        spacing: 20px;
        padding: 30px;
        fixed-height: false;
        scrollbar: false;
    }

    element {
        orientation: vertical;
        padding: 15px;
        border-radius: 12px;
        background-color: transparent;
    }

    element selected.normal {
        background-color: rgba(255, 255, 255, 0.05);
        border: 2px;
        border-color: @accent-alt;
        text-color: @accent-alt;
    }

    element-icon {
        size: 220px;
        horizontal-align: 0.5;
    }

    element-text {
        horizontal-align: 0.5;
        vertical-align: 0.5;
        padding: 10px 0 0 0;
        text-color: inherit;
    }

    inputbar {
        padding: 20px;
        background-color: rgba(255, 255, 255, 0.05);
        children: [prompt, entry];
    }
    ')

[ -z "$selected_wallpaper" ] && exit 0

image_fullname_path=$(find "$wallpapers_dir" -type f -name "$selected_wallpaper.*" | head -n 1)

awww img "$image_fullname_path" \
    --transition-type "$rand_anim" \
    --transition-duration 2 \
    --transition-fps 75 \
    --transition-step 90

wal -i "$image_fullname_path" -n -q

if [ -f "$HOME/.cache/wal/wob.ini" ]; then
    cp "$HOME/.cache/wal/wob.ini" "$HOME/.config/wob/wob.ini"
    pkill wob
    (tail -f $XDG_RUNTIME_DIR/wob.fifo | wob) &
fi

killall -SIGUSR2 waybar
swaync-client -rs

echo "Aplicado [$rand_anim]: $(basename "$image_fullname_path")"
