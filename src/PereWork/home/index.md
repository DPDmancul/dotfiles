# Home

```nix PereWork/home/default.nix
{ config, pkgs, lib, modules, ... }:
{
  imports = [
    /${modules}/home
    ./sway.nix
    ./packages.nix
  ];

  #<<<PereWork/home>>>
}
```

