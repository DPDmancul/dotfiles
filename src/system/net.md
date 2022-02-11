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

## DNS

Block tracking ads with AdGuard DNS

```nix "config" +=
networking.nameservers = [
  "127.0.0.1" "::1"
  # "94.140.14.14" "94.140.15.15"
  # "2a10:50c0::ad1:ff" "2a10:50c0::ad2:ff"
];
networking.resolvconf.enable = pkgs.lib.mkForce false;
networking.dhcpcd.extraConfig = "nohook resolv.conf";
networking.networkmanager.dns = "none";
services.resolved.enable = false;
```

Use DoH protocol

```nix "config" +=
services.dnscrypt-proxy2 = {
  enable = true;
  settings = {
    ipv6_servers = true;
    require_dnssec = true;

    sources.public-resolvers = {
      urls = [
        "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
      ];
      cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
      minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
    };

    server_names = [ "adguard-dns-doh" ];
  };
};
```

## WiFi key drivers

```nix "config" +=
boot.extraModulePackages = with config.boot.kernelPackages; [ rtl8821cu ];
boot.kernelModules = [ "8821cu" ];
```

