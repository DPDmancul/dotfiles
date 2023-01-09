# Networking

```nix PereBook/system/net.nix
{ config, pkgs, assets, lib, ... }:
{
  <<<PereBook/system/net>>>
}
```

## DHCP

The global useDHCP flag is deprecated, therefore explicitly set to false here.

Per-interface useDHCP will be mandatory in the future, so this config replicates the default behaviour.

```nix "PereBook/system/net" +=
networking = {
  useDHCP = false;
  interfaces.enp7s0.useDHCP = true;
  interfaces.wlp6s0.useDHCP = true;
};
```

## WiFi key drivers

```nix "PereBook/system/net" +=
boot = {
  extraModulePackages = with config.boot.kernelPackages; [ rtl8821cu ];
  kernelModules = [ "8821cu" ];
};
```

## VPN

Disable IPv6 since it is not supported

```nix "PereBook/system/net" +=
networking.enableIPv6 = false;

sops.secrets."vpn/openvpn-credentials-nordvpn" = {};
services.openvpn.servers = {
  vpn  = {
    config = ''
      config ${assets}/it238.nordvpn.com.udp.ovpn
      auth-user-pass ${config.sops.secrets."vpn/openvpn-credentials-nordvpn".path}
    '';
    updateResolvConf = true;
  };
};
```

