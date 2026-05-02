{ config, pkgs, lib, ... }:
{
  programs.regreet = {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
    iconTheme = {
      name = "Tela";
      package = pkgs.tela-icon-theme;
    };
  };
}
