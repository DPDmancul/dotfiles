{ config, pkgs, lib, ... }:
{
  programs.ssh = {
    enable = true;
    settings = {
      "git.mvlabs.it" = {
        user = "git";
        port = 4222;
      };
    };
  };
}
