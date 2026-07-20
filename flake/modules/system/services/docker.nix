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

  users.users."dpd-".extraGroups = lib.mkIf config.virtualisation.docker.enable [
    "docker"
  ];

  security.wrappers.docker-rootlesskit = {
    owner = "root";
    group = "root";
    capabilities = "cap_net_bind_service+ep";
    source = "${pkgs.rootlesskit}/bin/rootlesskit";
  };
}
