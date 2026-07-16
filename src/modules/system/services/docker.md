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

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  users.users."dpd-".extraGroups = lib.mkIf config.virtualisation.docker.enable [
    "docker"
  ];
}
```

