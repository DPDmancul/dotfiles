# JetBrains PhpStorm

```nix modules/home/packages/developing/phpstorm.nix
{ config, pkgs, lib, inputs, ... }:
{
  home.packages = with pkgs; [
    unfree.unstable.phpstorm
  ];
}
```

