#!/bin/bash

BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}#######################################################${NC}"
echo -e "${BLUE}#            BIENVENIDO A BURREROS INSTALLER          #${NC}"
echo -e "${BLUE}#######################################################${NC}"

echo -e "${CYAN}¿Deseas instalar el Kernel Zen (optimizado para rendimiento, recomendado si juegas)? [S/n]${NC}"
read -r install_zen
if [[ ! $install_zen =~ ^[Nn]$ ]]; then
    echo -e "${CYAN}[1/7] Instalando Kernel Zen...${NC}"
    sudo pacman -S --needed --noconfirm linux-zen linux-zen-headers
fi

echo -e "${CYAN}[2/7] Configurando Drivers Gráficos...${NC}"
echo -e "Selecciona tu tarjeta de video:"
echo -e "1) Intel"
echo -e "2) Nvidia"
echo -e "3) AMD"
echo -e "4) Ya tengro drivers, no gracias"
read -p "Opción: " gpu_choice

case $gpu_choice in
    1)
        sudo pacman -S --needed --noconfirm mesa lib32-mesa vulkan-intel lib32-vulkan-intel intel-media-driver
        ;;
    2)
        sudo pacman -S --needed --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings
        echo "options nvidia-drm modeset=1" | sudo tee /etc/modprobe.d/nvidia.conf
        ;;
    3)
        sudo pacman -S --needed --noconfirm mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon
        ;;
    *)
        echo -e "${RED}Omitiendo instalación de drivers...${NC}"
        ;;
esac

echo -e "${CYAN}[3/7] Instalando Hyprland ${NC}"
sudo pacman -S --needed --noconfirm hyprland waybar swaync rofi-wayland kitty swww wayland-protocols xdg-desktop-portal-hyprland qt5-wayland qt6-wayland polkit-gnome

echo -e "${CYAN}[4/7] Instalando Audio, Red, Bluetooth y Utilidades...${NC}"
sudo pacman -S --needed --noconfirm pipewire pipewire-pulse pipewire-alsa wireplumber thunar gvfs pavucontrol-qt fastfetch git bluez bluez-utils blueman network-manager-applet brightnessctl

echo -e "${CYAN}[5/7] Configurando Pantalla de inicio ${NC}"
sudo pacman -S --needed --noconfirm sddm qt5-graphicaleffects qt5-quickcontrols2 qt5-svg
sudo mkdir -p /usr/share/sddm/themes
if [ ! -d "/usr/share/sddm/themes/candy" ]; then
    sudo git clone https://github.com/Eisentein/candy-themes /usr/share/sddm/themes/candy
fi
sudo mkdir -p /etc/sddm.conf.d
echo -e "[Theme]\nCurrent=candy" | sudo tee /etc/sddm.conf.d/theme.conf
sudo systemctl enable sddm
sudo systemctl enable bluetooth

echo -e "${CYAN}[6/7] Aplicando configuraciones de BurrerOS...${NC}"
DOTFILES_DIR=$(pwd)
mkdir -p ~/.config
configs=("hypr" "waybar" "swaync" "rofi" "kitty" "Thunar" "qt5ct" "qt6ct")

for folder in "${configs[@]}"; do
    if [ -d "$DOTFILES_DIR/$folder" ]; then
        [ -e "$HOME/.config/$folder" ] && mv "$HOME/.config/$folder" "$HOME/.config/${folder}_bak"
        ln -s "$DOTFILES_DIR/$folder" "$HOME/.config/$folder"
        echo -e "${GREEN}Enlazado: $folder${NC}"
    fi
done

[ -f "$DOTFILES_DIR/pavucontrol-qt.conf" ] && ln -sf "$DOTFILES_DIR/pavucontrol-qt.conf" "$HOME/.config/pavucontrol-qt.conf"

echo -e "${BLUE}#######################################################${NC}"
echo -e "${GREEN}¡INSTALACIÓN COMPLETADA CON ÉXITO!${NC}"
echo -e "${CYAN}Bienvenido al sistema mas tuff de el big 26 twin${NC}"
echo -e "${RED}El sistema se reiniciará y se va a aplicar todo en 10 segundos...${NC}"
echo -e "${BLUE}#######################################################${NC}"

sleep 10
sudo reboot
