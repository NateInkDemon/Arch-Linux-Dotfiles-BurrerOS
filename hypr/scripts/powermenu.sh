#!/bin/bash

shutdown="  Apagar"
reboot="󰜉  Reiniciar"
lock="  Bloquear"
suspend="󰤄  Suspender"
logout="󰈆  Cerrar Sesión"

selected=$(echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi -dmenu -i -p "Menú de Sistema" \
-theme-str 'window {width: 40%; border: 2px; border-color: #ffffff;}' \
-theme-str 'listview {lines: 5; scrollbar: false;}' \
-theme-str 'element {padding: 20px;}')

case "$selected" in
    "$shutdown") systemctl poweroff ;;
    "$reboot") systemctl reboot ;;
    "$lock") hyprlock ;;
    "$suspend") systemctl suspend ;;
    "$logout") hyprctl dispatch exit 0 ;;
esac
