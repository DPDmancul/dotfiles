# User packages

```nix PereWork/home/packages.nix
{ config, pkgs, lib, modules, ... }:
{
  imports = [
    /${modules}/home/xdg.nix
    /${modules}/home/packages/developing/dotnet.nix
    /${modules}/home/packages/developing/rider.nix
    /${modules}/home/packages/developing/node.nix
  ];

  home.packages = with pkgs; let
    openvpn_legacy = openvpn.override { openssl = openssl_legacy; };
  in
  [
    #<<<PereWork/home/packages-packages>>>
    keepassxc
    appimage-run
    openvpn
    (writeScriptBin "openvpn_legacy" ''${openvpn_legacy}/bin/openvpn "$@"'')
    openconnect
    vpn-slice
    remmina
    postgresql # TODO install only client
    unfree.dropbox-cli # TODO with home manager
    unfree.postman
    unfree.ngrok
  ];

  #<<<PereWork/home/packages>>>
}
```

