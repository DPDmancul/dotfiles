{ config, pkgs, lib, ... }:
{
  programs.firefox = {
    profiles.default = {
      settings = {
        "browser.startup.page" = 3;
      };
    };
  };
}
