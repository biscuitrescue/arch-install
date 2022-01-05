#!/usr/bin/env bash

echo "Please enter username for new user: "
read user
if [ -d /sys/firmware/efi ]; then
    ;
else
    echo "Enter name of device (/dev/sdX)"
    read device

locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "Locales are done"

ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
systemctl enable ntpd
echo "Timezone has been configured"

echo "archbox" > /etc/hostname
echo "hostname has been set"

echo "127.0.0.1     localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1     archbox" >> /etc/hosts
echo "network has been configured"

echo "Please enter password for root user:"
passwd

### SUDO

echo "root ALL=(ALL) ALL" > /etc/sudoers
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
echo "@includedir /etc/sudoers.d" >> /etc/sudoers
pacman -S sudo --noconfirm

useradd -mG tty,users,video,lp,input,audio,wheel $user
echo Enter password for $user
passwd $user

pacman --needed --noconfirm -S grub grub-btrfs dosfstools mtools f2fs-tools btrfs-progs
if [ -d /sys/firmware/efi ] ; then
    pacman -S efibootmgr
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --removable --recheck
else
    grub-install --target=i386-pc $device
fi
grub-mkconfig -o /boot/grub/grub.cfg
echo "bootloader has been installed"

pacman --needed --noconfirm --ask 4 -S - < install.txt 
pacman --needed -S tlp

systemctl enable NetworkManager
systemctl enable tlp
systemctl enable fstrim.timer

usermod -aG vboxusers $user
chsh -s /usr/bin/fish $user
