# Bootloader

Use systemd-boot EFI bootloader

```nix "config" +=
boot.loader = {
  systemd-boot.enable = true;
  efi.canTouchEfiVariables = true;
};
```

Reduce timeout to 2 seconds

```nix "config" +=
boot.loader.timeout = 2;
```

