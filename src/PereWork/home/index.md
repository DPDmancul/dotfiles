# Home

```nix PereWork/home/default.nix
{ config, pkgs, lib, modules, ... }:
{
  imports = [
    /${modules}/home
    ./i3.nix
    ./git.nix
    ./ssh.nix
    ./firefox.nix
    ./claude.nix
    # /${modules}/home/packages/qemu.nix
    ./packages.nix
  ];

  #<<<PereWork/home>>>
}
```

