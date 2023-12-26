# System

```nix PereWork/system/default.nix
{ config, pkgs, inputs, modules, sops, lib, ... }:
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

Enable unfree wireless drivers. This must be done manually, since `enableAllFirmware` requires `pkgs` to directly contain unfree packages.

```nix "PereWork/system" +=
hardware = {
  enableAllFirmware = false;
  firmware = with pkgs.unfree; [
    broadcom-bt-firmware
    b43Firmware_5_1_138
    b43Firmware_6_30_163_46
    xow_dongle-firmware
    facetimehd-firmware
    facetimehd-calibration
  ];
};
```

```nix "unfree-extra" +=
"broadcom-bt-firmware"
"b43-firmware"
"xow_dongle-firmware"
"facetimehd-firmware"
"facetimehd-calibration"
```

Enable unfree video drivers.

```nix "unfree-extra" +=
"nvidia-x11"
"nvidia-settings"
```

Enable virtualisation

```nix "modules/system" +=
virtualisation = {
  libvirtd.enable = true;
  virtualbox.host.enable = true;
};
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
  "192.168.69.2" = [ "k8sd-topbest-imel.i4paintshop.com" "argocd-topbest-imel.i4paintshop.com" "pgad-topbest-imel.i4paintshop.com" ];
};
```

## Teamviewer

<!-- TODO: move -->

```nix "unfree-extra" +=
"teamviewer"
```

```nix "PereWork/system" +=
services.teamviewer.enable = true;
```

## Certificates

```nix "PereWork/system" +=
sops.secrets."ca/PereWork.pem" = {};
security.pki.certificateFiles = [ config.sops.secrets."ca/PereWork.pem".path ];
```
