# Networking

## Hostname

```nix "config" +=
networking.hostName = "nixos";
```

## Wireless

```nix "config" +=
# networking.wireless.enable = true;
```

## DHCP

The global useDHCP flag is deprecated, therefore explicitly set to false here.

Per-interface useDHCP will be mandatory in the future, so this config replicates the default behaviour.

```nix "config" +=
networking.useDHCP = false;
networking.interfaces.ens3.useDHCP = true;
```

