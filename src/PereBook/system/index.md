# System

```nix PereBook/system/default.nix
{ config, pkgs, inputs, secrets, modules, lib, ... }:
{
  imports = with inputs.hardware.nixosModules; [
    common-pc-laptop
    common-pc-laptop-ssd
    common-pc-laptop-hdd
    common-cpu-intel
    common-gpu-intel
  ] ++ [
    /${modules}/system
    ./hardware-configuration.nix
    ./net.nix
    ./services.nix
    /${modules}/system/services/print_scan/brotherDCP1612W.nix
    ./users.nix
  ];

  <<<PereBook/system>>>
}
```

## Hardware

Mount data filesystem

```nix "PereBook/system" +=
fileSystems."/home/dpd-/datos" = {
  device = "/dev/disk/by-uuid/42681448-3710-4f0b-9778-994a23c7f17e";
  fsType = "ext4";
  options = [ "noatime" ];
};
```

Enable BTRFS compression

```nix "PereBook/system" +=
fileSystems."/".options = [ "compress=zstd" ];
```

Enable pen tablet FOSS drivers

```nix "PereBook/system" +=
hardware.opentabletdriver.enable = true;
```

## Timezone

```nix "PereBook/system" +=
time.timeZone = "Europe/Rome";
```

## Sway

Sway is configured with home-manager but must be activated also at system level to set the environment (eg. opengl, dconf, ...)

```nix "PereBook/system" +=
programs.sway = {
  enable = true;
  wrapperFeatures.gtk = true;
  extraPackages = [ ];
};
```

Grant PAM access to swaylock

```nix "PereBook/system" +=
security.pam.services.swaylock = {
  text = "auth include login";
};
```
