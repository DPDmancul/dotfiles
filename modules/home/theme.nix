{ config, pkgs, lib, ... }:
{
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = "adwaita";
      package = pkgs.adwaita-qt;
    };
  };
  gtk.enable = true;
  gtk.iconTheme = {
    name = "Tela";
    package = pkgs.tela-icon-theme;
  };
  dconf.settings."org/gnome/desktop/interface" = {
    icon-theme = config.gtk.iconTheme.name;
  };
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
  };
}
