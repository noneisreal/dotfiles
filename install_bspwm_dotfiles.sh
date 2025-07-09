#!/bin/bash

# Dotfiles Installer Script for BSPWM setup
# Author: noneisreal
# Description: Backup old config, create symlinks, and auto-install required packages

set -e

REPO_DIR="$(pwd)"
CONFIGS=("bspwm" "sxhkd" "polybar" "rofi" "picom")
DEST="$HOME/.config"
BACKUP_DIR="$HOME/.config_backup_$(date +%s)"

echo "[*] Backing up existing configs to $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

for config in "${CONFIGS[@]}"; do
    TARGET="$DEST/$config"
    if [[ -e "$TARGET" ]]; then
        echo " → Backing up $config"
        mv "$TARGET" "$BACKUP_DIR/"
    fi
done

echo "[*] Creating symlinks from repository..."
for config in "${CONFIGS[@]}"; do
    SRC="$REPO_DIR/$config"
    DEST_DIR="$DEST/$config"

    if [[ -d "$SRC" ]]; then
        echo " → Linking $config"
        ln -sf "$SRC" "$DEST_DIR"
    else
        echo " [!] Skipping $config — not found in repo"
    fi
done

echo "[*] Detecting package manager..."
if command -v pacman &> /dev/null; then
    echo "[+] Arch-based system detected. Installing packages..."
    sudo pacman -S --needed bspwm sxhkd polybar rofi picom dunst kitty
elif command -v apt &> /dev/null; then
    echo "[+] Debian-based system detected. Installing packages..."
    sudo apt update
    sudo apt install -y bspwm sxhkd polybar rofi picom dunst kitty
else
    echo "[!] Unknown package manager. Please install these manually: bspwm sxhkd polybar rofi picom dunst kitty"
fi

echo "[✔] Setup completed successfully!"
