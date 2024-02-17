#! /bin/bash

# Run after chrooting

read -p "Install grub to MBR? (y/n): " INSTALL_GRUB
if [ $INSTALL_GRUB = "y" ]; then
    pacman -S grub
    read -p "Grub Partition (e.g. sda): " GRUB_PARTITION
    grub-install --target=i386-pc /dev/$GRUB_PARTITION
    read -p "Rename wireless interface to wlan0? (y/n): " RENAME_WLAN
    if [ $RENAME_WLAN = "y" ]; then
        sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="net.ifnames=0"/' /etc/default/grub
    fi
    grub-mkconfig -o /boot/grub/grub.cfg
else
    read -p "Install grub to EFI? (y/n): " INSTALL_GRUB
    if [ $INSTALL_GRUB = "y" ]; then
        pacman -S grub efibootmgr dosfstools
        read -p "EFI Partition: " EFI_PARTITION
        mkdir efi
        mkfs.fat -F32 /dev/$EFI_PARTITION
        mount /dev/$EFI_PARTITION /efi
        grub-install --target=x86_64-efi --efi-directory=efi --bootloader=GRUB
        read -p "Rename wireless interface to wlan0? (y/n): " RENAME_WLAN
        if [ $RENAME_WLAN = "y" ]; then
            sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="net.ifnames=0"/' /etc/default/grub
        fi
        grub-mkconfig -o /boot/grub/grub.cfg
    fi
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
usermod -aG docker $USER_NAME

read -p "Install display manager? (y/n): " INSTALL_DM

if [ $INSTALL_DM = "y" ]; then
    pacman -S xorg-xdm
    systemctl enable xdm.service
fi

systemctl enable docker.service

echo "If you need to change the GRUB config, edit /etc/default/grub"
echo "and then grub-mkconfig -o /boot/grub/grub.cfg"

echo "Please exit and reboot"
