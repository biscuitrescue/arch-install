#!/usr/bin/env bash

dire=`pwd`

mkdir -p ~/git
cd ~/git

if [[ `pacman -Qq | grep -i paru-bin` ]]; then
	:
else
	git clone https://aur.archlinux.org/paru-bin
	cd paru-bin
	makepkg -sri
fi

cd $dire

for i in `cat paru.txt`; do
	if [[ `pacman -Qq | grep -i $i` ]]; then
		:
	else
		paru -S $i
	fi
done

echo "All AUR Packages have been installed"
