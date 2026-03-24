#!/bin/bash

USER_NAME="jpablo"
CONFIG_DIR="/home/$USER_NAME/.config/waybar"
STATE_FILE="$CONFIG_DIR/scripts/.current_bar"

# Si el archivo no existe o está vacío, empezamos en 1
if [ ! -s "$STATE_FILE" ]; then echo "1" > "$STATE_FILE"; fi

# LEER EL ESTADO ACTUAL
CURRENT=$(cat "$STATE_FILE")

# LÓGICA DE SELECCIÓN
if [ "$1" == "random" ]; then
    # Al inicio (boot), elegimos una al azar del 1 al 4
    NEXT=$(( ( RANDOM % 4 )  + 1 ))
else
    # Si es clic manual, seguimos el orden 1 -> 2 -> 3 -> 4 -> 1
    case $CURRENT in
        1) NEXT=2 ;;
        2) NEXT=3 ;;
        3) NEXT=4 ;;
        4) NEXT=1 ;;
        *) NEXT=1 ;;
    esac
fi

# Guardar el nuevo estado para el siguiente clic
echo "$NEXT" > "$STATE_FILE"

pkill waybar
while pgrep -u $USER -x waybar >/dev/null; do sleep 0.1; done
sleep 0.1

# Ejecutar la configuración correspondiente
case $NEXT in
    1)
        waybar -c "$CONFIG_DIR/config_alt.jsonc" -s "$CONFIG_DIR/style_alt.css" &>/dev/null &
        ;;
    2)
        waybar -c "$CONFIG_DIR/config_win.jsonc" -s "$CONFIG_DIR/style_solid.css" &>/dev/null &
        ;;
    3)
        waybar -c "$CONFIG_DIR/config.jsonc" -s "$CONFIG_DIR/style.css" &>/dev/null &
        ;;
    4)
        # NUEVA BARRA LATERAL DERECHA
        waybar -c "$CONFIG_DIR/config_side.jsonc" -s "$CONFIG_DIR/style_side.css" &>/dev/null &
        ;;
esac

disown
exit 0
