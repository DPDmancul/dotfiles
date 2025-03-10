{ config, pkgs, lib, ... }:
{
  programs.librewolf = {
    profiles.default.settings = {
      "browser.startup.page" = 3;
    };
  };
}
