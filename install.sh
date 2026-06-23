#!/bin/bash

if [ "$EUID" -eq 0 ]; then
    echo "please do not run this script as root. it will ask for your password when needed."
    exit 1
fi

read -p "install dotfiles? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "ok bye"
    exit 1
fi

echo "installing standard packages..."
sudo pacman -S --needed --noconfirm base-devel git hyprland kitty fish rofi waybar swaync swayosd yazi micro fastfetch btop mpd rmpc zathura stow python firefox nautilus networkmanager wireplumber cliphist wl-clipboard playerctl qalculate-gtk grim slurp fd fzf xdg-utils libnotify polkit-gnome network-manager-applet hypridle mpc mpd-mpris numlockx ffmpeg

echo "checking for aur helper..."
if command -v yay &> /dev/null; then
    aur="yay"
elif command -v paru &> /dev/null; then
    aur="paru"
else
    echo "installing yay..."
    mkdir -p ~/.local/src
    git clone https://aur.archlinux.org/yay-bin.git ~/.local/src/yay-bin
    cd ~/.local/src/yay-bin
    makepkg -si --noconfirm
    cd - > /dev/null
    aur="yay"
fi

echo "installing aur packages..."
$aur -S --needed --noconfirm matugen awww rofi-wayland ttf-jetbrains-mono-nerd localsend-bin bluetui

echo "stowing dotfiles..."
stow */ -t ~

echo "copying wallpapers..."
mkdir -p ~/Pictures/Wallpapers
cp -r hypr/.config/hypr/modes/walls/* ~/Pictures/Wallpapers/ 2>/dev/null || true

echo "setting default wallpaper..."
mkdir -p ~/.config/hypr
if [ ! -f ~/.config/hypr/current_wallpaper ]; then
    ln -sf ~/Pictures/Wallpapers/night.jpg ~/.config/hypr/current_wallpaper
fi

echo "all done!"
