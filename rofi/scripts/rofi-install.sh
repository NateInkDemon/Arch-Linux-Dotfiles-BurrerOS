#!/usr/bin/env bash

BLUE='\e[1;34m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
RED='\e[1;31m'
CYAN='\e[1;36m'
ITALIC='\e[3m'
NC='\e[0m'

CRITICAL_PKGS="hyprland|networkmanager|waybar|linux|grub|sudo|kitty|pacman|yay|pipewire|mesa|sddm"

if [ -z "$@" ]; then
    echo "Busca arriba el paquete a instalar..."
    echo "1. Desinstalar (Ver Lista y Borrar)"
    echo "2. Actualizar Sistema Completo"
else
    pkg_choice="$@"

    kitty --class rofi_terminal -e sh -c "
        while true; do
            clear
            if [[ '$pkg_choice' == '1'* ]]; then
                echo -e '${BLUE}--- LISTA DE PAQUETES (PACMAN/YAY) ---${NC}'
                pacman -Qq | awk -v crit=\"$CRITICAL_PKGS\" '{
                    if (\$1 ~ \"^(\" crit \")$\")
                        print \"\033[1;31m\" \$1 \" [PELIGRO]\033[0m\";
                    else
                        print \$1;
                }' | column
                echo ''
                echo -e '${GREEN}--- LISTA DE PAQUETES (FLATPAK) ---${NC}'
                flatpak list --columns=application
                echo ''
                echo -e '${YELLOW}INSTRUCCIONES:${NC}'
                echo 'Dale hacia arriba y veras los ids y nombres de los paquetes que hay en tu sistema'
                echo 'Borrar normal:  yay -Rns nombre'
                echo 'Borrar Flatpak: flatpak uninstall ID'
                echo ''
                read -p 'Comando a ejecutar: ' final_cmd
                [ -n \"\$final_cmd\" ] && eval \$final_cmd

            elif [[ '$pkg_choice' == '2'* ]]; then
                echo -e '${CYAN}--- INICIANDO ACTUALIZACION TOTAL ---${NC}'

                # Tu lógica de checkupdates integrada
                updates=\$(checkupdates 2>/dev/null | wc -l)
                echo -e '${BLUE}Paquetes pendientes: \$updates${NC}\n'

                echo -e '${YELLOW}1. Actualizando Repositorios y AUR (Yay)...${NC}'
                yay -Syu --noconfirm

                echo -e '\n${YELLOW}2. Actualizando Flatpaks...${NC}'
                flatpak update -y

                echo -e '\n${YELLOW}3. Limpiando paquetes huerfanos...${NC}'
                orphans=\$(pacman -Qtdq)
                if [ -n \"\$orphans\" ]; then
                    sudo pacman -Rns \$orphans --noconfirm
                else
                    echo 'No hay paquetes huerfanos para limpiar.'
                fi

                echo -e '\n${GREEN}Sistema al dia.${NC}'

            else
                echo -e '${CYAN}Instalando: $pkg_choice${NC}'
                if ! yay -S $pkg_choice; then
                    echo -e '\n${RED}Error: No se encontro el paquete o fallo la descarga.${NC}'
                else
                    echo -e '\n${GREEN}Instalacion completada.${NC}'
                fi
            fi

            echo ''
            echo -e '${CYAN}S para continuar / Enter para salir${NC}'
            read -p '¿Hacer otra cosa?: ' cont
            if [[ \$cont =~ ^[sS]\$ ]]; then
                read -p 'Nombre del paquete o accion (1/2): ' next_step
                [ -z \"\$next_step\" ] && break
                pkg_choice=\"\$next_step\"
            else
                break
            fi
        done
        echo -e '${CYAN}Cerrando...${NC}'
        sleep 1" &

    pkill rofi
    exit 0
fi
