# System

```nix PereWork/system/default.nix
{ config, pkgs, inputs, modules, sops, lib, ... }:
{
  imports = with inputs.hardware.nixosModules; [
    common-pc-laptop
    common-pc-laptop-ssd
    # lenovo-thinkpad-p16s-intel-gen3:
    common-cpu-intel#-arrow-lake
    common-gpu-intel#-arrow-lake
  ] ++ [
    /${modules}/system
    ./hardware-configuration.nix
    ./net.nix
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

Enable virtualisation

```nix "PereWork/system" +=
virtualisation = {
  # libvirtd.enable = true;
  # virtualbox.host.enable = true;
};
```

## Hardware

Enable BTRFS compression

```nix "PereWork/system" +=
fileSystems."/".options = [ "compress=zstd" ];
```

Enable BTRFS auto scrub

```nix "PereWork/system" +=
services.btrfs.autoScrub.enable = true;
```

## Power management

TODO: tlp-pd

```nix "PereWork/system" +=
services.tlp.enable = true;
```

## Hosts

```nix "PereWork/system" +=
networking.hosts = {
  "10.14.201.215" = [ "k8sd-plant-jft-mvlabs.vidim.it" ];
  "192.168.69.2" = [ "k8sd-topbest-imel.i4paintshop.com" "argocd-topbest-imel.i4paintshop.com" "pgad-topbest-imel.i4paintshop.com" ];
  "192.168.3.245" = [ "sg.inplant.live" "sg.inplant.io" ];
};
```

## Teamviewer

<!-- TODO: move -->

```nix "unfree-extra" +=
"teamviewer"
```

```nix "PereWork/system" +=
# services.teamviewer.enable = true;
```

## Certificates

```nix "PereWork/system" +=
sops.secrets."ca/PereWork.pem" = {};
# security.pki.certificateFiles = [ config.sops.secrets."ca/PereWork.pem".path ];
```
