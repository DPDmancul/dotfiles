# System

```nix configuration.nix
{ config, pkgs, lib, ... }:
let secrets = import ../secrets.nix;
in {
  <<<config>>>
}
```

## Hardware

Include the results of the hardware scan

```nix "config" +=
imports = [ /etc/nixos/hardware-configuration.nix ];

fileSystems."/home/dpd-/datos" = { 
  device = "/dev/sda2";
  fsType = "ext4";
};
```

Enable BTRFS compression

```nix "config" +=
fileSystems."/".options = [ "compress=zstd" "noatime" ];
```

Enable pen tablet FOSS drivers

```nix "config" +=
hardware.opentabletdriver.enable = true;
```

## Timezone

```nix "config" +=
time.timeZone = "Europe/Rome";
```

## Environment

```nix "config" +=
environment.sessionVariables = {
  <<<env>>>
};
```

## Enable NTFS support

```nix "config" +=
boot.supportedFilesystems = [ "ntfs" ];
```

## Optimise Nix store

Automatically de-duplicate for newer derivations

```nix "config" +=
nix.autoOptimiseStore = true;
```

## Sway

Sway is configured with home-manager but must be activated also at system level to set the environment (eg. opengl, dconf, ...)

```nix "config" +=
programs.sway = {
  enable = true;
  wrapperFeatures.gtk = true;
  extraPackages = [];
};
```

## State version

**DO NOT TOUCH!**

```nix "config" +=
system.stateVersion = "21.11";
```

