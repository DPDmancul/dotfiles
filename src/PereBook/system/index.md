# System

```nix PereBook/system/default.nix
{ config, pkgs, inputs, secrets, lib, ... }:
{
  imports = with inputs.hardware.nixosModules; [
    common-pc-laptop
    common-pc-laptop-ssd
    common-pc-laptop-hdd
    common-cpu-intel
    common-gpu-intel
  ] ++ [
    ./net.nix
  ];

  <<<PereBook/system>>>
  # TODO remove in favour of PereBook/system
  <<<config>>>
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

