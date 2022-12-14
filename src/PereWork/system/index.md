# System

```nix PereWork/system/default.nix
{ config, pkgs, inputs, modules, lib, ... }:
{
  imports = with inputs.hardware.nixosModules; [
    common-pc-laptop
    common-pc-laptop-ssd
    common-cpu-intel
    # lenovo-thinkpad-p50
    common-pc-laptop-acpi_call
  ] ++ [
    /${modules}/system
    ./hardware-configuration.nix
    ./net.nix
    /${modules}/system/sway.nix
    ./users.nix
  ];

  nixpkgs.config.allowUnfree = true; # For hardware config
  hardware.enableAllFirmware = true; # For wireless

  <<<PereWork/system>>>
}
```

Enable unfree drivers

```nix "unfree-extra" +=
"broadcom-bt-firmware"
"b43-firmware"
"xow_dongle-firmware"
"facetimehd-firmware"
"facetimehd-calibration"
# "nvidia-x11"
# "nvidia-settings"
```

## Hardware

Enable BTRFS compression

```nix "PereWork/system" +=
fileSystems."/".options = [ "compress=zstd" ];
```

