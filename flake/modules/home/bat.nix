{ config, pkgs, lib, ... }:
{
  programs.bat = {
    enable = true;
    themes.jb-light = {
      src = ./bat;
      file = "jb-light.tmTheme";
    };
    config.theme = "jb-light";
  };
}
