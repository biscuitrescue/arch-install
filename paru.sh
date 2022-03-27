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
paru --needed --ask 4 -S - < paru.txt 
