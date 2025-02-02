{ config, pkgs, lib, ... }:
{
  programs.firefox = {
    profiles.default = {
      settings = {
        "network.trr.mode" = 2;
      };
    };
  };
}
