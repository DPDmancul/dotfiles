# Bootloader

Use GRUB2 as bootloader

```nix "config" +=
boot.loader.grub.enable = true;
boot.loader.grub.version = 2;
# boot.loader.grub.efiSupport = true;
# boot.loader.grub.efiInstallAsRemovable = true;
# boot.loader.efi.efiSysMountPoint = "/boot/efi";
boot.loader.grub.device = "/dev/sda";
```


