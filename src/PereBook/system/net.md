# Networking

```nix PereBook/system/net.nix
{ config, pkgs, assets, lib, ... }:
{
  <<<PereBook/system/net>>>
}
```

## WiFi key drivers

```nix "PereBook/system/net" +=
boot = {
  extraModulePackages = with config.boot.kernelPackages; [ rtl8821cu ];
  kernelModules = [ "8821cu" ];
};
```

## VPN

```nix "PereBook/system/net" +=
sops.secrets."vpn/openvpn-credentials-nordvpn" = {};

services.openvpn.servers = {
  vpn  = {
    config = ''
      config ${assets}/it238.nordvpn.com.udp.ovpn
      auth-user-pass ${config.sops.secrets."vpn/openvpn-credentials-nordvpn".path}
    '';
    autoStart = false; # TODO fix reconnect after wi-fi drops
  };
};
```

