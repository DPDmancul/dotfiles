# Qemu

```nix modules/home/packages/qemu.nix
{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    qemu
    virt-manager
  ];

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
```

