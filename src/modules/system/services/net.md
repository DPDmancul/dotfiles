# Networking

```nix modules/system/services/net.nix
{ config, pkgs, assets, lib, users, ... }:
{
  <<<modules/system/services/net>>>
}
```

## Networkd

Manage networks with networkd; use iwd as wifi backend.

```nix "modules/system/services/net" +=
networking = {
  useNetworkd = true;
  wireless.iwd.enable = true;
};

environment.systemPackages = with pkgs; [
  iwgtk
];
```

Disable annoying awaiting being online at startup

```nix "modules/system/services/net" +=
systemd.network.wait-online = {
  anyInterface = true;
  timeout = 0;
};
```

## Bonding

TODO

```nix "modules/system/services/net" +=
# networking.bonds.bond0 = {
#   interfaces = [
#     "enp7s0"
#     "wlan0"
#   ];
#   driverOptions.mode = "active-backup";
# };
# systemd.network.networks = {
#   "40-bond0".networkConfig.DHCP = "yes";
#   "40-enp7s0".networkConfig.PrimarySlave = "yes";
# };
```

OR

```nix "modules/system/services/net" +=
# systemd.network = {
#   netdevs."10-bond0" = {
#     netdevConfig = {
#       Name = "bond0";
#       Kind = "bond";
#     };
#     bondConfig.Mode = "active-backup";
#   };
#   networks = let
#     bond = "bond0";
#   in {
#     "10-${bond}" = {
#       matchConfig.Name = bond;
#       networkConfig.DHCP = "yes";
#     };
#     "20-${bond}-eth" = {
#       matchConfig.Name = [ "en*" "eth*" ];
#       networkConfig = {
#         Bond = bond;
#         PrimarySlave = "yes";
#       };
#     };
#     "20-${bond}-wlan" = {
#       matchConfig.Name = "wl*";
#       networkConfig.Bond = bond;
#     };
#   };
# };
```

## Wireless networks

```nix "modules/system/services/net" +=
sops.secrets."wireless.env".sopsFile = /${assets}/secrets/wireless.yaml;

networking.wireless = {
  environmentFile = config.sops.secrets."wireless.env".path;
  networks = {
    IDR_CASA.psk = "@IDR_CASA_PSK@";
    "MV Labs Guests".psk = "@MV_Labs_Guests_PSK@";
  };
};
```

