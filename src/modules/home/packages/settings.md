# Settings

GUI for easily manage settings.

```nix modules/home/packages/settings.nix
{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    pavucontrol # audio
    pamixer
    wdisplays   # screen
  ];
}
```

