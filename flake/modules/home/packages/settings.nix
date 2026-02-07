{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    pavucontrol # audio
    pamixer
    arandr      # screen (X11)
    wdisplays   # screen (wayland)
    libsecret   # secret-tool
    glib        # gsettings
  ];
}
