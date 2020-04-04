#! /bin/bash

# Prior to this, must connect to internet, partition+format disk
# Run this script like bash <(curl -s URL)

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

    base-devel
    python
    git
    vim
    lua
    perl
    go
    jdk-openjdk

    xorg
    i3
    termite

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

mount /dev/$INSTALL_PARTITION /mnt
pacstrap /mnt ${PACSTRAP_PACKAGES[@]}
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

read -p "Install grub to MBR? (y/n): " INSTALL_GRUB
if [ $INSTALL_GRUB = "y" ]; then
    pacman -S grub
    read -p "Grub Partition (e.g. sda): " GRUB_PARTITION
    grub-install --target=i386-pc /dev/$GRUB_PARTITION
    grub-mkconfig -o /boot/grub/grub.cfg
fi

echo "Setting timezone..."
ln -sf /usr/share/zoneinfo/America/Detroit /etc/localtime
hwclock --systohc

echo "Setting up locale..."
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "Setting up hostname..."
read -p "Hostname: " HOST_NAME
echo $HOST_NAME > /etc/hostname
echo "127.0.0.1 $HOST_NAME" >> /etc/hosts
echo "::1 $HOST_NAME" >> /etc/hosts
echo "127.0.1.1 $HOST_NAME.localdomain $HOST_NAME" >> /etc/hosts

echo "Setting root password..."
passwd

echo "Setting up user..."
read -p "Username: " USER_NAME
useradd -m -G wheel $USER_NAME
passwd $USER_NAME
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

mkdir .config && cd .config
git clone git@github.com:mkgs/dotfiles.git

echo "Please exit and reboot"
