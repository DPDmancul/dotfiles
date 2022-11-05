# Networking

## Hostname

```nix "config" +=
networking.hostName = "nixos";
```

## NetworkManager

```nix "config" +=
networking.networkmanager.enable = true;
```

## DHCP

The global useDHCP flag is deprecated, therefore explicitly set to false here.

Per-interface useDHCP will be mandatory in the future, so this config replicates the default behaviour.

```nix "config" +=
networking = {
  useDHCP = false;
  interfaces.enp7s0.useDHCP = true;
  interfaces.wlp6s0.useDHCP = true;
};
```

## WiFi key drivers

```nix "config" +=
boot = {
  extraModulePackages = with config.boot.kernelPackages; [ rtl8821cu ];
  kernelModules = [ "8821cu" ];
};
```

## VPN

Disable IPv6 since it is not supported

```nix "config" +=
networking.enableIPv6 = false;
```

```nix "config" +=
services.openvpn.servers = {
  vpn  = {
    config = "config ${./it238.nordvpn.com.udp.ovpn}";
    updateResolvConf = true;
    authUserPass = secrets.vpn;
  };
};
```

