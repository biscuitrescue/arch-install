#!/usr/bin/env python3

from os.path import exists
from subprocess import run
from shutil import copyfile

def install(pkg):
    cmd="pacman --needed --noconfirm -S "+pkg
    run(cmd, shell=True)

def install_all(files):
    run("pacman --needed --noconfirm --ask 4 -S - < {}".format(files), shell=True)

def install_more(pkgs):
    with open("packages.txt", "w") as f:
        for i in pkgs:
            f.write(i)
    install_all("packages.txt")


while True:
    yes_no=input("Do you want to install all packages[Y/N]: ")
    if yes_no not in "YyNn":
        print("Invalid response. Please enter again")
    else:
        if yes_no in "nN":
            waste_of_time=False
            break
        elif yes_no in "yY":
            waste_of_time=True
            break

### Check for UEFI

if exists("/sys/firmware/efi"):
    UEFI=True
else:
    grub_disk=input("Enter your grub device: ")
    UEFI=False

### USERS and PASSES

copyfile("pacman.conf", "/etc/pacman.conf")

user_name=input("Enter your username: ")
cmd="useradd -mG tty,video,audio,lp,input,audio,wheel {}".format(user_name)

run(cmd, shell=True)
print()

cmd="passwd "+user_name
run(cmd, shell=True)
print()

print("Enter password for root user: ")
run("passwd")
print()

### Locales

print("Configuring Locales ...")
print()


with open("/etc/locale.gen") as f:
    locale_gen=f.readlines()

for i in locale_fen:
    if i.strip()=="#en_US.UTF-8 UTF-8":
        i="en_US.UTF-8 UTF-8\n"

with open("/etc/locale.gen", "w") as f:
    for i in locale_gen:
        f.write(i)

run("locale-gen")

with open("/etc/locale.conf", "w") as f:
    f.write("en_US.UTF-8 UTF-8\n")

print("Locales are done")
print()


print("Configuring Timezones ...")
run("ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime", shell=True)
run(["hwclock", "--systohc"])
print("Timezones have been configured")

print()

host_name=input("Enter hostname: ")


with open("/etc/hostname", "w") as f:
    f.write(host_name)

print()

print("Configuring Networking ...")

with open("/etc/hosts" "a") as f:
    f.write("127.0.0.1\t\tlocalhost")
    f.write("::1\t\tlocalhost")
    f.write("127.0.1.1\t\t{}".format(host_name))

print("Network has been configured")
print()

print("Configuring sudo ...")
copyfile("sudoers", "/etc/sudoers")
install("sudo")
print("Done")
print()

print("Installing some packages")
packages=[
    "grub",
    "dosfstools",
    "mtools",
    "f2fs-tools",
    "btrfs-progs",
    "xfsprogs",
    "xfsdump",
    "ntp",
    "networkmanager",
    "network-manager-applet",
    "xorg-server"
]
print()
install_more(packages)
print()

print("Installing Grub")
if UEFI:
    install("efibootmgr")
    run("grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --removabel --recheck", shell=True)
else:
    run("grub-install --target=i386-pc {}".format(grub_disk), shell=True)

run("grub-mkconfig -o /boot/grub/grub.cfg", shell=True)

print("Grub has been configured")
print()

if waste_of_time:
    install_all("install.txt")
    run("usermod -aG vboxusers "+user_name)

install("tlp")

enable=[
    "tlp",
    "NetworkManager",
    "fstrim.timer",
    "ntpd",
]

for service in enable:
    cmd="systemctl enable {}".format(service)
    run(cmd, shell=True)

print("Base system has been installed\nPlease run paru.sh as {}".format(user_name))
print("Terminating ...")
