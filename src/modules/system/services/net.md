# Networking

```nix modules/system/services/net.nix
{ config, pkgs, assets, lib, users, ... }:
{
  <<<modules/system/services/net>>>

  users.users = lib.genAttrs users (user: {
    extraGroups = [
      <<<modules/system/services/net-user-groups>>>
    ];
  });
}
```

## NetworkManager

Manage networks with NetworkManager

```nix "modules/system/services/net" +=
networking.networkmanager.enable = true;
```

```nix "modules/system/services/net-user-groups" +=
"networkmanager"
```

Automatically symlink all configurations with sops-nix

```nix "modules/system/services/net" +=
sops.secrets = let
  sopsFile = /${assets}/secrets/nm.yaml;
in with lib; with builtins; genAttrs
  (filter isString
    (concatMap (match ''([^ \t#"][^:]*):.*|"([^"])":.*|.*'') 
               (splitString "\n" (readFile sopsFile))))
  (key: mkIf (key != "sops") {
    path = "/etc/NetworkManager/system-connections/${key}";
    inherit sopsFile;
  });
```

TODO: call `sudo nmcli con reload`
