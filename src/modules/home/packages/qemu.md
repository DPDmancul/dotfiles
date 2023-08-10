# Qemu

```nix modules/home/packages/qemu.nix
{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    qemu
    virt-manager
  ];
}
```

