#!/usr/bin/env bash

HYPRGAMEMODE="$HOME/.cache/gamemode_enabled"

if [ -f "$HYPRGAMEMODE" ]; then
    hyprctl reload
    rm "$HYPRGAMEMODE"
    notify-send "System" "Gamemode deactivated" -i joystick
else
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"

    touch "$HYPRGAMEMODE"
    notify-send "System" "Gamemode activated" -i joystick
fi
