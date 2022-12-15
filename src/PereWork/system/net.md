# Networking

```nix PereWork/system/net.nix
{ config, pkgs, lib, ... }:
{
  <<<PereWork/system/net>>>
}
```

## DHCP

The global useDHCP flag is deprecated, therefore explicitly set to false here.

Per-interface useDHCP will be mandatory in the future, so this config replicates the default behaviour.

```nix "PereWork/system/net" +=
networking = {
  useDHCP = false;
  # interfaces.enp0s31f6.useDHCP = true;
  # interfaces.wlp4s0.useDHCP = true;
};
```

