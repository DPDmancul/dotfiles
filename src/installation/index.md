# Install NixOS

<!--
```sh installation.sh +=
#!/bin/sh

if ! nc -zxw1 nixos.org 443 2> /dev/null; then
  echo "Please connect to internet"
  exit
fi

if [ "$EUID" -ne 0 ]; then
  echo "Start this script a root"
  exit
fi
```
-->

1. Run the live image of NixOS.
2. Switch to root:
   ```sh
   sudo -i
   ```
3. Connect to the network following the guide.

   It could be useful to read the guide while doing installation:
   ```sh
   screen
   nixos-help
   # C-a S
   # C-a c
   # Switch region with C-a tab
   ```
4. Partition the disk.

   ```sh installation.sh +=
   SWAP=8GiB
   dev=/dev/sda
   ```

   Example for UEFI systems:

   ```sh installation.sh +=
   parted $dev -- mklabel gpt

   parted $dev -- mkpart primary 512MiB -$SWAP
   parted $dev -- mkpart primary linux-swap -$SWAP 100%

   parted $dev -- mkpart ESP fat32 1MiB 512MiB
   parted $dev -- set 3 esp on
   ```

5. Optionally encrypt the main partition:

   ```sh installation.sh +=
   cryptsetup luksFormat "$dev"1
   cryptsetup open "$dev"1 nixenc
   ```

6. Format the partitions:

   ```sh installation.sh +=
   mkfs.btrfs -L root /dev/mapper/nixenc

   mkswap -L swap "$dev"2
   swapon "$dev"2

   mkfs.fat -F 32 -n boot "$dev"3
   ```

7. Optionally create subvolumes (btrfs only):

   ```sh installation.sh +=
   mount -t btrfs /dev/mapper/nixenc /mnt/
   btrfs subvol create /mnt/nixos
   umount /mnt
   mount -t btrfs -o subvol=nixos /dev/mapper/nixenc /mnt

   btrfs subvol create /mnt/home
   ```

8. Mount the boot partition:

   ```sh installation.sh +=
   mkdir /mnt/boot
   mount "$dev"3 /mnt/boot
   ```

9. Generate config and install:

   ```sh installation.sh +=
   nixos-generate-config --root /mnt
   nixos-install
   ```

