# User packages

This is a collection of common packages and related integration with other programs.

```nix modules/home/packages/default.nix
{ config, pkgs, lib, ... }:
{
  imports = [
    ./utils.nix
    ./settings.nix
    ./libreoffice.nix
    ./nemo.nix
  ];
}
```

