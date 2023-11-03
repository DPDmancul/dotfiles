{ config, pkgs, lib, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "git.mvlabs.it" = {
        user         = "git";
        identityFile = "~/.ssh/MVLabsGit";
      };

      "10.227.15.64" = {
        identityFile = "~/.ssh/MVLabsGit";
      };

    };
  };
}
