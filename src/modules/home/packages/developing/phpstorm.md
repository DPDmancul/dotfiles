# JetBrains PhpStorm

```nix modules/home/packages/developing/phpstorm.nix
{ config, pkgs, lib, inputs, ... }:
{
  home.packages = with pkgs; [
    # use jdk 21.0.6 since newer jdks use wrong mouse cursor and apply a wrong window geometry
    (unfree.callPackage "${inputs.unstable}/pkgs/applications/editors/jetbrains/default.nix" { inherit (pkgs."25.05".jetbrains) jdk; }).phpstorm
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

