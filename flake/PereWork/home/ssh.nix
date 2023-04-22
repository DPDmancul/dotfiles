{ config, pkgs, lib, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "git.mvlabs.it" = {
        user         = "git";
        identityFile = "~/.ssh/MVLabsGit";
      };
    };
  };
}
