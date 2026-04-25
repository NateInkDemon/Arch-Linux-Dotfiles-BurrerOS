#!/bin/bash

SET_GREEN=$(tput setaf 2)
SET_BLUE=$(tput setaf 4)
SET_BOLD=$(tput bold)
RESET=$(tput sgr0)

echo -e "${SET_BLUE}${SET_BOLD}==> Iniciando instalación y despliegue de BurrerOS <==${RESET}"

PACMAN_PKGS=(
    "hyprland" "hyprlock" "uwsm" "waybar" "swaync" "rofi" "rofimoji"
    "kitty" "fish" "yazi" "btop" "awww" "python-pywal" "nwg-look"
    "kvantum" "papirus-icon-theme" "ly" "brightnessctl" "pavucontrol"
    "wl-clipboard" "cliphist" "wob" "otf-monaspace-nerdfonts"
    "fastfetch" "cmatrix" "cava" "git" "base-devel"
)

AUR_PKGS=(
    "spicetify-cli" "spotify" "zen-browser-bin" "equibop-bin"
)

echo -e "\n${SET_GREEN}${SET_BOLD}[1/5] Instalando paquetes oficiales...${RESET}"
sudo pacman -Syu --needed --noconfirm "${PACMAN_PKGS[@]}"

echo -e "\n${SET_GREEN}${SET_BOLD}[2/5] Verificando AUR Helper...${RESET}"
if command -v paru &> /dev/null; then HELPER="paru"; 
elif command -v yay &> /dev/null; then HELPER="yay"; 
else
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin && makepkg -si --noconfirm && cd -
    HELPER="yay"
fi

echo -e "\n${SET_GREEN}${SET_BOLD}[3/5] Instalando paquetes de AUR...${RESET}"
$HELPER -S --needed --noconfirm "${AUR_PKGS[@]}"

echo -e "\n${SET_GREEN}${SET_BOLD}[4/5] Clonando Dotfiles desde GitHub...${RESET}"
DOTS_DIR="$HOME/Downloads/Arch-Linux-Dotfiles-BurrerOS"

rm -rf "$DOTS_DIR"
git clone https://github.com/NateInkDemon/Arch-Linux-Dotfiles-BurrerOS.git "$DOTS_DIR"

echo -e "${SET_BLUE}Copiando configuraciones a ~/.config...${RESET}"
mkdir -p "$HOME/.config"

cp -rf "$DOTS_DIR/hypr" "$HOME/.config/"
cp -rf "$DOTS_DIR/waybar" "$HOME/.config/"
cp -rf "$DOTS_DIR/kitty" "$HOME/.config/"
cp -rf "$DOTS_DIR/rofi" "$HOME/.config/"
cp -rf "$DOTS_DIR/swaync" "$HOME/.config/"
cp -rf "$DOTS_DIR/wob" "$HOME/.config/"
cp -rf "$DOTS_DIR/fastfetch" "$HOME/.config/"
cp -rf "$DOTS_DIR/yazi" "$HOME/.config/"

echo -e "\n${SET_GREEN}${SET_BOLD}[5/5] Habilitando servicios...${RESET}"
sudo systemctl enable ly.service
sudo systemctl enable bluetooth.service

echo -e "\n${SET_BLUE}${SET_BOLD}¡BurrerOS está listo! Reinicia para ver los cambios.${RESET}"
