#! /bin/bash

# Run after chrooting

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

git clone https://github.com/VundleVim/Vundle.vim.git /home/$USER_NAME/.vim/bundle/Vundle.vim
mkdir /home/$USER_NAME/.config && cd /home/$USER_NAME/.config
git clone https://github.com/mkgs/dotfiles.git
cp dotfiles/.bashrc ../
cp dotfiles/.bash_profile ../
cp dotfiles/.bash_aliases ../
cp dotfiles/.vimrc ../
cp dotfiles/.xinitrc ../
cp -r dotfiles/.config/ ../

echo "Please exit and reboot"
