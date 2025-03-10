{ config, pkgs, lib, ... }:
{
  programs.librewolf = {
    profiles.default.settings = {
      "network.trr.mode" = 2;
    };
  };
}
