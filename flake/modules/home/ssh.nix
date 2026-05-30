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
      "gitlab.com" = {
        user         = "git";
        identityFile = "~/.ssh/dpd-GitLab";
      };
      "github.com" = {
        user         = "git";
        identityFile = "~/.ssh/dpd-GitHub";
      };
    };
  };
  # <<<modules/home/ssh>>>
}
