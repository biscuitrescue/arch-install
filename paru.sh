#!/usr/bin/env bash

chsh -s /bin/fish

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

for i in `cat txt/paru.txt`; do
	if [[ `pacman -Qq | grep -i $i` ]]; then
		:
	else
		paru -S $i
	fi
done

echo "All AUR Packages have been installed"

cd ~/git
git clone https://github.com/biscuitrescue/qtile-laptop qtile
cp -r qtile ~/.config
rm -rf qtile

git clone https://github.com/biscuitrescue/Wallpapers

cp -r Wallpapers ~/Pictures/
rm -rf Wallpapers

git clone https://github.com/biscuitrescue/shells
cd shells/
cp -r {fish/, starship.toml} ~/.config/
cd ../

curl -sS https://starship.rs/install.sh | sh

git clone https://github.com/biscuitrescue/vim-nvim nvim
mv nvim/doom.d/ ~/.doom.d
cp -r nvim ~/.config/ && rm -rf nvim

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

if [[ `pacman -Q | grep -i emacs` ]]; then
	git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
	~/.emacs.d/bin/doom install
else
	echo
	echo "Emacs not installed on system"
	echo
fi

sudo pacman -S --needed --noconfirm libxfce4ui polkit

git clone https://github.com/ncopa/xfce-polkit.git
cd xfce-polkit
meson build
cd build
meson --prefix=/usr ..
ninja
ninja install
sudo cp build/xfce-polkit /usr/bin/
cd ..

sudo pacman -S tk
git clone https://github.com/biscuitrescue/scripts
cd scripts/
sudo cp -r scripts/* /usr/bin/
suod cp -r python/* /usr/bin/
cd ~/git

git clone https://github.com/biscuitrescue/dmenu
cd dmenu
mv dmscripts ~/
sudo make install
cd ..

git clone https://github.com/biscuitrescue/kitty
cp -r kitty ~/.config/ && rm -rf kitty

git clone https://github.com/biscuitrescue/picom
cp -r picom ~/.config && rm -rf picom

cd ~/
touch .fehbg
echo "#!/bin/sh" >> .fehbg
echo "feh --no-fehbg --bg-scale ~/Pictures/Wallpapers/nerd.png"

git clone https://github.com/powerline/fonts
./fonts/install.sh
rm -rf fonts

wget 'https://fontsfree.net//wp-content/fonts/basic/various-basic/FontsFree-Net-OperatorMono-Medium.ttf'
mv FontsFree-Net-OperatorMono-Medium.ttf ~/.local/share/fonts/

wget 'https://fontsfree.net//wp-content/fonts/basic/FontsFree-Net-OperatorMono-Book.ttf'
mv FontsFree-Net-OperatorMono-Book.ttf ~/.local/share/fonts/

wget 'https://fontsfree.net//wp-content/fonts/basic/FontsFree-Net-OperatorMono-BookItalic-1.ttf'
mv FontsFree-Net-OperatorMono-BookItalic-1.ttf ~/.local/share/fonts/

wget 'https://fontsfree.net//wp-content/fonts/basic/various-basic/FontsFree-Net-OperatorMono-Bold.ttf'
mv FontsFree-Net-OperatorMono-Bold.ttf ~/.local/share/fonts/

git clone https://github.com/40huo/Patched-Fonts.git
cd Patched-Fonts/
cp -r camingo-code/* ~/.local/share/fonts
cp -r sf-mono-nerd-font/* ~/.local/share/fonts
cp -r operator-mono-nerd-font/* ~/.local/share/fonts

paru -S --needed nerd-fonts-cascadia-code nerd-fonts-droid-sans-mono nerd-fonts-fantasque-sans-mono nerd-fonts-hasklig nerd-fonts-jetbrains-mono nerd-fonts-mononoki nerd-fonts-source-code-pro nerd-fonts-terminus ttf-iosevka-nerd


echo "Done"
echo 
echo "Terminating ..."
