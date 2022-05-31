# Bootloader

Use systemd-boot EFI bootloader

```nix "config" +=
boot.loader = {
  systemd-boot = {
    enable = true;
    # Remove old generation profiles to avoid
    # have a full boot partition
    configurationLimit = 10; 
  };
  efi.canTouchEfiVariables = true;
};
```

Reduce timeout to 2 seconds

```nix "config" +=
boot.loader.timeout = 2;
```

# Temporary File System

Use RAM to store temporary files

```nix "config" +=
boot.tmpOnTmpfs = true;
```

