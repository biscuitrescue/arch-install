#!/usr/bin/env python3

from subprocess import run, Popen, PIPE
from modules import install, check_installed, paru
from os import getcwd, mkdir, chdir
from shutil import copyfile
from os.path import exists

install("fish")

a=Popen("echo $HOME", shell=True, stdout=PIPE)
home_dir=a.communicate()[0].decode().strip()+'/'
dire=getcwd()

copy=["xinitrc", "xprofile", "Xresources"]

for i in copy:
    file1="configs/{}".format(i)
    file2="{}.{}".format(home_dir, i)
    copyfile(file1, file2)

if exists(home_dir+"git"):
    print("Exists")
else:
    mkdir(home_dir+"git")

chdir(home_dir+"git")

installed=check_installed("paru-bin")

if installed==False:
    run(
        "git clone https://aur.archlinux.org/paru-bin.git",
        shell=True
    )
    run(
        "cd paru-bin && makepkg -sri && cd ../",
        shell=True
    )

with open("txt/paru.txt") as f:
    packages=f.readlines()

for i in packages:
    i.strip()
    inst=check_installed(i)
    if inst==False:
        paru(i)

print("All AUR packages have been installed")
print()
