# Autorandr

```nix PereWork/home/autorandr.nix
{ config, pkgs, lib, ... }:
{
  programs.autorandr = {
    enable = true;
    profiles = {
      "scrivanie" = {
        config = {
          DP-6.position = "0x0";
          DP-4.position = "2560x0";
          eDP-1.position = "5120x0";
        };
      };
    };
  };
}
```

