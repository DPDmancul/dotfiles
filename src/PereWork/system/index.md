# System

```nix PereWork/system/default.nix
{ config, pkgs, inputs, modules, lib, ... }:
{
  imports = with inputs.hardware.nixosModules; [
    common-pc-laptop
    common-pc-laptop-ssd
    common-cpu-intel
    lenovo-thinkpad-p50
    common-pc-laptop-acpi_call
  ] ++ [
    /${modules}/system
    ./hardware-configuration.nix
    ./users.nix
    ./autorandr.nix
  ];

  <<<PereWork/system>>>
}
```

Enable all wireless drivers. `allowUnfree` is needed because `enableAllFirmware` assert it to be true, but being this a flake it doesn't really work

```nix "PereWork/system" +=
nixpkgs.config.allowUnfree = true;
hardware.enableAllFirmware = true;
```

now really enable unfree drivers

```nix "unfree-extra" +=
"broadcom-bt-firmware"
"b43-firmware"
"xow_dongle-firmware"
"facetimehd-firmware"
"facetimehd-calibration"
"nvidia-x11"
"nvidia-settings"
```

## Hardware

Enable BTRFS compression

```nix "PereWork/system" +=
fileSystems."/".options = [ "compress=zstd" ];
```

### nvidia

Disable offload mode, otherwise X won't start

```nix "PereWork/system" +=
services.xserver.videoDrivers = [ "nvidia" ];
hardware.nvidia.prime.offload.enable = false;
```

## Hosts

```nix "PereWork/system" +=
networking.hosts = {
  "10.14.201.215" = [ "k8sd-plant-jft-mvlabs.vidim.it" ];
};
```
