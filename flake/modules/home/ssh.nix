{ config, pkgs, lib, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false; # to be ready for future releases of home-manager
    settings = {
      "*" = {
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlMaster = "auto";
        controlPersist = "10m";
        identitiesOnly = true;
      };
    };
  };
  # <<<modules/home/ssh>>>
}
