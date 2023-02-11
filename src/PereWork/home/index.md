# Home

```nix PereWork/home/default.nix
{ config, pkgs, lib, modules, ... }:
{
  imports = [
    /${modules}/home
    /${modules}/home/wm/i3.nix
    /${modules}/home/gnome
    ./git.nix
    ./ssh.nix
    ./sway.nix
    ./firefox.nix
    ./rider.nix
    ./packages.nix
  ];

  #<<<PereWork/home>>>
}
```

