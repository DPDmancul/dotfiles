# Docker

```nix PereWork/system/docker.nix
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

