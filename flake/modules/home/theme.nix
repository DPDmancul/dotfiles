{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    (inputs.feh-random-background + /home-manager-service.nix)
  ];

  qt = {
    enable = true;
    platformTheme = "gnome";
    style.name = "adwaita";
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
    x11.enable = true;
  };
  xdg.configFile."gtk-4.0/gtk.css".text = ''
    window {
      padding: 0;
      box-shadow: none;
    }
  '';
  xdg.configFile."gtk-3.0/gtk.css".text = ''
    decoration {
      padding: 0;
    }
  '';
  dconf.settings."org/gnome/desktop/wm/preferences".button-layout = "";
  xdg.configFile."gtk-3.0/settings.ini".text = ''
     gtk-decoration-layout=:menu
  '';
  services.feh-random-background = {
    enable = true;
    imageDirectory = "${inputs.wallpapers}";
    interval = "1m";
  };
  programs.autorandr = {
    enable = true;
    hooks.postswitch = {
      "reload-background" = "systemctl --user start feh-random-background";
    };
  };
}
