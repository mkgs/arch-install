#! /bin/bash

# Prior to this, must connect to internet, partition+format disk
# Run this script like bash <(curl -Ls URL)

echo "///// Arch install helper"
echo "This script assumes you've already connected to internet and partitioned the disk!!"

timedatectl set-ntp true

PACSTRAP_PACKAGES=(
    base
    linux
    linux-firmware

    netctl
    dialog
    wpa_supplicant
    openssh
    wireless_tools
    iw
    dhcpcd

    base-devel
    python
    git
    vim
    lua
    perl
    go
    jdk-openjdk

    xorg
    xorg-xinit
    i3
    dmenu
    termite
    xterm
    tamsyn-font
    terminus-font
    noto-fonts
    gnu-free-fonts
    noto-fonts-cjk

    curl
    wget
    feh
    mc
    ranger
    htop
)

AUDIO_PACKAGES=(
    vlc
)

BROWSER_PACKAGES=(
    firefox
    chromium
)

MEDIA_PACKAGES=(
    gimp
    audacity
)

OFFICE_PACKAGES=(
    libreoffice-still
)

read -p "Install graphical browsers? (y/n): " INSTALL_BROWSERS
read -p "Install LibreOffice? (y/n): " INSTALL_LIBRE
read -p "Install audio packages? (y/n): " INSTALL_AUDIO
read -p "Install media software? (y/n): " INSTALL_MEDIA

if [ $INSTALL_BROWSERS = "y" ]; then
    PACSTRAP_PACKAGES+=("${BROWSER_PACKAGES[@]}")
fi

if [ $INSTALL_LIBRE = "y" ]; then
    PACSTRAP_PACKAGES+=("${OFFICE_PACKAGES[@]}")
fi

if [ $INSTALL_AUDIO = "y" ]; then
    PACSTRAP_PACKAGES+=("${AUDIO_PACKAGES[@]}")
fi

if [ $INSTALL_MEDIA = "y" ]; then
    PACSTRAP_PACKAGES+=("${MEDIA_PACKAGES[@]}")
fi

read -p "Set up swap partition? (y/n): " SETUP_SWAP
if [ $SETUP_SWAP = "y" ]; then
    read -p "Swap partition (e.g. sda2): " SWAP_PARTITION
    mkswap /dev/$SWAP_PARTITION
    swapon /dev/$SWAP_PARTITION
fi

read -p "OS Partition (e.g. sda1): " INSTALL_PARTITION
read -p "Format Partition? (y/n): " FORMAT_PARTITION

if [ $FORMAT_PARTITION = "y" ]; then
    mkfs.ext4 /dev/$INSTALL_PARTITION
fi

mount /dev/$INSTALL_PARTITION /mnt
pacstrap /mnt ${PACSTRAP_PACKAGES[@]}
genfstab -U /mnt >> /mnt/etc/fstab
echo "Chrooting to /mnt - please run postroot script"
arch-chroot /mnt

