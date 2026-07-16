# Docker

```nix modules/system/services/docker.nix
{ config, pkgs, lib, assets, ... }:
{
  virtualisation.docker = {
    enable = !config.virtualisation.docker.rootless.enable;
    storageDriver = "btrfs";

    rootless = {
      enable = true;
      setSocketVariable = true;
      daemon.settings = {
        storage-driver = config.virtualisation.docker.storageDriver;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  users.users."dpd-".extraGroups = [
    "docker"
  ];
}
```

