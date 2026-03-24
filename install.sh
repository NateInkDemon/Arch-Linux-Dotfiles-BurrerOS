#!/bin/bash

BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}#######################################################${NC}"
echo -e "${BLUE}#            BIENVENIDO A BURREROS INSTALLER          #${NC}"
echo -e "${BLUE}#######################################################${NC}"

echo -e "${CYAN}¿Deseas instalar el Kernel Zen (Un kernel mas optimizado, recomendado si juegas)? [S/n]${NC}"
read -r install_zen

if [[ $install_zen =~ ^[Nn]$ ]]; then
    echo -e "${RED}Ok no lo descargues, sigamos${NC}"
else
    echo -e "${CYAN}[1/6] Instalando Kernel Zen y demas cosas...${NC}"
    sudo pacman -S --needed --noconfirm linux-zen linux-zen-headers
fi

echo -e "${CYAN}[2/6] Instalando Hyprland ${NC}"
sudo pacman -S --needed --noconfirm hyprland waybar swaync rofi-wayland kitty swww wayland-protocols xdg-desktop-portal-hyprland qt5-wayland qt6-wayland polkit-gnome

echo -e "${CYAN}[3/6] Instalando cosas esenciales (Audio, Red, Bluetooth)...${NC}"
sudo pacman -S --needed --noconfirm pipewire pipewire-pulse pipewire-alsa wireplumber thunar gvfs pavucontrol-qt fastfetch git bluez bluez-utils blueman network-manager-applet brightnessctl

echo -e "${CYAN}[4/6] Configurando pantalla de inicio ${NC}"
sudo pacman -S --needed --noconfirm sddm qt5-graphicaleffects qt5-quickcontrols2 qt5-svg
sudo mkdir -p /usr/share/sddm/themes

if [ ! -d "/usr/share/sddm/themes/candy" ]; then
    sudo git clone https://github.com/Eisentein/candy-themes /usr/share/sddm/themes/candy
fi
sudo mkdir -p /etc/sddm.conf.d
echo -e "[Theme]\nCurrent=candy" | sudo tee /etc/sddm.conf.d/theme.conf
sudo systemctl enable sddm
sudo systemctl enable bluetooth

echo -e "${CYAN}[5/6] Aplicando configuraciones de BurrerOS...${NC}"
DOTFILES_DIR=$(pwd)
mkdir -p ~/.config
configs=("hypr" "waybar" "swaync" "rofi" "kitty" "Thunar" "qt5ct" "qt6ct")

for folder in "${configs[@]}"; do
    if [ -d "$DOTFILES_DIR/$folder" ]; then
        if [ -e "$HOME/.config/$folder" ]; then
             echo "Respaldando $folder..."
             mv "$HOME/.config/$folder" "$HOME/.config/${folder}_bak"
        fi
        ln -s "$DOTFILES_DIR/$folder" "$HOME/.config/$folder"
        echo -e "${GREEN}Enlazado: $folder${NC}"
    fi
done

[ -f "$DOTFILES_DIR/pavucontrol-qt.conf" ] && ln -sf "$DOTFILES_DIR/pavucontrol-qt.conf" "$HOME/.config/pavucontrol-qt.conf"

echo -e "${BLUE}#######################################################${NC}"
echo -e "${GREEN}¡INSTALACIÓN COMPLETADA CON ÉXITO!${NC}"
echo -e "${CYAN}Bienvenido al sistema mas tuff de el big 26 twin${NC}"
echo -e "${RED}El sistema se reiniciará en 10 segundos...${NC}"
echo -e "${BLUE}#######################################################${NC}"

sleep 10
sudo reboot
