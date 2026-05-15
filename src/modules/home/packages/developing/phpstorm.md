# JetBrains PhpStorm

```nix modules/home/packages/developing/phpstorm.nix
{ config, pkgs, lib, inputs, ... }:
{
  home.packages = with pkgs; [
    unfree.unstable.jetbrains.phpstorm
  ];
}
```

## X debug

Open X debug port

```nix "PereWork/system/net" +=
networking.firewall = {
  allowedTCPPorts = [ 43768 ];
};
```

