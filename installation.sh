#!/bin/sh

if ! nc -zxw1 nixos.org 443 2> /dev/null; then
  echo "Please connect to internet"
  exit
fi

if [ "$EUID" -ne 0 ]; then
  echo "Start this script as root"
  exit
fi
SWAP=8GiB
dev=/dev/sda
parted $dev -- mklabel gpt

parted $dev -- mkpart primary 512MiB -$SWAP
parted $dev -- mkpart primary linux-swap -$SWAP 100%

parted $dev -- mkpart ESP fat32 1MiB 512MiB
parted $dev -- set 3 esp on
cryptsetup luksFormat "$dev"1
cryptsetup open "$dev"1 nixenc
mkfs.btrfs -L root /dev/mapper/nixenc

mkswap -L swap "$dev"2
swapon "$dev"2

mkfs.fat -F 32 -n boot "$dev"3
mount -t btrfs /dev/mapper/nixenc /mnt/
btrfs subvol create /mnt/nixos
umount /mnt
mount -t btrfs -o subvol=nixos /dev/mapper/nixenc /mnt

btrfs subvol create /mnt/home
mkdir /mnt/boot
mount "$dev"3 /mnt/boot
nixos-generate-config --root /mnt
nixos-install
