#!/usr/bin/env bash

if [ -d /sys/firmware/efi ]; then
    :
else
    read -p "Please enter device name (/dev/sdX)" device
fi

locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "Locales are done"

ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
echo "Timezone has been configured"

echo "archbox" > /etc/hostname
echo "hostname has been set"

echo "127.0.0.1     localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1     archbox" >> /etc/hosts
echo "network has been configured"


### SUDO

echo "root ALL=(ALL) ALL" > /etc/sudoers
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
echo "@includedir /etc/sudoers.d" >> /etc/sudoers
pacman -S sudo --noconfirm

read -p "Please enter username for new user: " user
useradd -mG tty,users,video,lp,input,audio,wheel $user
echo Enter password for $user
passwd $user
echo "Please enter password for root user:"
passwd

pacman --needed --noconfirm -S grub grub-btrfs dosfstools mtools f2fs-tools btrfs-progs xfsprogs xfsdump ntp networkmanager network-manager-applet xorg-server
if [ -d /sys/firmware/efi ] ; then
    pacman -S efibootmgr
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --removable --recheck
else
    grub-install --target=i386-pc $device
fi
grub-mkconfig -o /boot/grub/grub.cfg
echo "bootloader has been installed"

while true; do
    read -p "Do you want to install all packages from txt[Y/N]" choice
    case $choice in
        [nN]*)
            break
            ;;
        [yY]*)
            pacman --needed --noconfirm --ask 4 -S - < install.txt
            pacman --needed -S tlp
            systemctl enable tlp
            usermod -aG vboxusers $user
            chsh -s /usr/bin/fish $user
            exit 1
            ;;
        *)
            echo "Invalid, please choose again">&2
    esac
done

systemctl enable NetworkManager
systemctl enable fstrim.timer
systemctl enable ntpd

echo "Please switch user and run paru.sh"
