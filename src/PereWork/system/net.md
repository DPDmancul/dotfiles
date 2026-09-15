# Networking

```nix PereWork/system/net.nix
{ config, pkgs, assets, lib, ... }:
{
  <<<PereWork/system/net>>>
}
```

## VPN

```nix "PereWork/system/net" +=
sops.secrets = {
  "vpn/openvpn-config-office" = {};
  "vpn/openvpn-credentials-office" = {};
};

services.openvpn.servers = {
  office  = {
    config = ''
      config ${config.sops.secrets."vpn/openvpn-config-office".path}
      auth-user-pass ${config.sops.secrets."vpn/openvpn-credentials-office".path}
    '';
    updateResolvConf = true;
    autoStart = false;
  };
};
```

