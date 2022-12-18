# Sway

Config displays position

```nix PereWork/home/sway.nix
{ config, pkgs, lib, ... }:
{
  wayland.windowManager.sway.config.output = {
    DP-6.pos = "0,0";
    DP-4.pos = "2560,0";
    eDP-1.pos = "5120,0";
  };
}
```

