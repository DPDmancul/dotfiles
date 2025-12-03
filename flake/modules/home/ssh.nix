{ config, pkgs, lib, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false; # to be ready for 26.05
    matchBlocks = {
      "*" = {
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlMaster = "auto";
        controlPersist = "10m";
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
