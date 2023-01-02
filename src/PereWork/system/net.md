# Networking

```nix PereWork/system/net.nix
{ config, pkgs, lib, ... }:
{
  <<<PereWork/system/net>>>
}
```

## Bond interfaces

Bond ethernet and wifi to give precedence to the former

TODO: make it work with NixOs config. Now it works via nmtui config

```nix "PereWork/system/net" +=
# networking.bonds.bond0 = {
#   interfaces = [ "enp0s31f6" "wlp4s0" ];
#   driverOptions = {
#     miimon = "100";
#     mode = "active-backup";
#     primary = "enp0s31f6";
#   };
# };
# systemd.network.networks.enp0s31f6.networkConfig.PrimarySlave = true;
```

