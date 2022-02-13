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
    static.adguard-dns-doh.stamp = "sdns://AgMAAAAAAAAADzE3Ni4xMDMuMTMwLjEzMCCaOjT3J965vKUQA9nOnDn48n3ZxSQpAcK6saROY1oCGQ9kbnMuYWRndWFyZC5jb20KL2Rucy1xdWVyeQ";
    server_names = [ "adguard-dns-doh" ];

    forwarding_rules = let
      router = "192.168.1.1";
    in pkgs.writeText "forwarding-rules.txt" ''
      lan              ${router}
      local            ${router}
      home             ${router}
      home.arpa        ${router}
      internal         ${router}
      localdomain      ${router}
      192.in-addr.arpa ${router}
    '';
  };
};
```

### Captive portal

Manual enable Wiffi captive portal

```nix "config" +=
networking.hosts."192.168.19.253" = [ "mt.wiffi.it" ];
networking.hosts."52.19.181.253" = [ "autenticazione.wiffi.it" ];
```
## WiFi key drivers

```nix "config" +=
boot.extraModulePackages = with config.boot.kernelPackages; [ rtl8821cu ];
boot.kernelModules = [ "8821cu" ];
```

