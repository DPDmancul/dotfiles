# System

```nix PereBook/system/default.nix
{ config, pkgs, inputs, modules, lib, ... }:
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
    /${modules}/system/sway.nix
    /${modules}/system/i3.nix
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

