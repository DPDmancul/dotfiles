{ config, pkgs, lib, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "gitlab.com" = {
        user         = "git";
        identityFile = "~/.ssh/dpd-GitLab";
      };
      "github.com" = {
        user         = "git";
        identityFile = "~/.ssh/dpd-GitHub";
      };
    };
    controlMaster = "auto";
    controlPersist = "10m";
  };
  # <<<modules/home/ssh>>>
}
