# Bootloader

Use systemd-boot EFI bootloader

```nix modules/system/boot.nix
{ config, pkgs, lib, ... }:
{
  boot.loader = {
    systemd-boot = {
      enable = true;
      # Remove old generation profiles to avoid
      # have a full boot partition
      configurationLimit = 20;
    };
    efi.canTouchEfiVariables = true;
  };

  <<<modules/system/boot>>>
}
```

Reduce timeout to 2 seconds

```nix "modules/system/boot" +=
boot.loader.timeout = 2;
```

# Temporary File System

Use RAM to store temporary files

```nix "modules/system/boot" +=
boot.tmp.useTmpfs = true;
```

