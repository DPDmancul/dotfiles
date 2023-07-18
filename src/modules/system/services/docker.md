# Docker

```nix modules/system/services/docker.nix
{ config, pkgs, lib, assets, ... }:
{
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  users.users."dpd-".extraGroups = [
    "docker"
  ];
}
```

