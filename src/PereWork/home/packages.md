# User packages

```nix PereWork/home/packages.nix
{ config, pkgs, lib, modules, ... }:
{
  imports = [
    /${modules}/home/xdg.nix
    /${modules}/home/packages/developing/dotnet.nix
  ];

  home.packages = with pkgs; [
    #<<<PereWork/home/packages-packages>>>
  ];

  #<<<PereWork/home/packages>>>
}
```

