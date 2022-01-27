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
networking.useDHCP = false;
networking.interfaces.wlp2s0.useDHCP = true;
```

## WiFi key drivers

```nix "packages" +=
config.boot.kernelPackages.rtl8821cu
```

