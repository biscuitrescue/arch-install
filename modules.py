#!/usr/bin/env python3

from subprocess import run

def install(pkg):
    cmd="pacman --needed --noconfirm -S "+pkg
    run(cmd, shell=True)

def install_all(files):
    run("pacman --needed --noconfirm --ask 4 -S - < {}".format(files), shell=True)

def install_more(pkgs):
    with open("packages.txt", "w") as f:
        for i in pkgs:
            f.write(i+'\n')
    install_all("packages.txt")
