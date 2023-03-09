# Autorandr

```nix PereWork/system/autorandr.nix
{ config, pkgs, lib, ... }:
{
  services.autorandr = {
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

