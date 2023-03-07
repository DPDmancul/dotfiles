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
    ./docker.nix
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

