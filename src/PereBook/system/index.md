# System

```nix PereBook/system/default.nix
{ config, pkgs, inputs, modules, lib, ... }:
{
  imports = with inputs.hardware.nixosModules; [
    common-pc-laptop
    common-pc-laptop-ssd
    # T16 and P16s gen4 with AMD are the same
    lenovo-thinkpad-p16s-amd-gen4
  ] ++ [
    /${modules}/system
    ./hardware-configuration.nix
    ./disko.nix
    ./net.nix
    ./services.nix
    /${modules}/system/services/print_scan/brotherDCP1612W.nix
    ./users.nix
  ];

  <<<PereBook/system>>>
}
```

## Hardware

Enable BTRFS auto scrub

```nix "PereBook/system" +=
services.btrfs.autoScrub.enable = true;
```

## Power management

```nix "PereBook/system" +=
services.tlp = {
  enable = true;
  pd.enable = true;
};
```

