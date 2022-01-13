#!/usr/bin/env bash

dire=`pwd`
cd git

mkdir -p ~/git
pacman -Qq > ~/git/check.txt
if grep -q 'paru-bin' ~/git/check.txt
	:
else
	git clone https://aur.archlinux.org/paru-bin.git
	cd paru-bin
	makepkg -sri
fi

cd $dire
paru --needed --noconfirm --ask 4 -S - < paru.txt 
