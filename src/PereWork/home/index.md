# Home

```nix PereWork/home/default.nix
{ config, pkgs, lib, modules, ... }:
{
  imports = [
    /${modules}/home
    ./packages.nix
  ];

  #<<<PereWork/home>>>
}
```

