# Home

```nix PereWork/home/default.nix
{ config, pkgs, lib, modules, ... }:
{
  imports = [
    /${modules}/home
    ./ssh.nix
    ./sway.nix
    ./rider.nix
    ./packages.nix
  ];

  #<<<PereWork/home>>>
}
```

