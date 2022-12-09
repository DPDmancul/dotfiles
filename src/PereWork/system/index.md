# System

```nix PereWork/system/default.nix
{ config, pkgs, inputs, modules, lib, ... }:
{
  imports = with inputs.hardware.nixosModules; [
    common-pc-laptop
    # TODO:
    # common-pc-laptop-ssd
    # common-pc-laptop-hdd
    # common-cpu-intel
    # common-gpu-intel
  ] ++ [
    /${modules}/system
    ./hardware-configuration.nix
    ./net.nix
    /${modules}/system/sway.nix
    ./users.nix
  ];

  <<<PereWork/system>>>
}
```

## Hardware

Enable BTRFS compression

```nix "PereWork/system" +=
fileSystems."/".options = [ "compress=zstd" ];
```

