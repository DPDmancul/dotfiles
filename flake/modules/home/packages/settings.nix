{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    pavucontrol # audio
    pamixer
    arandr      # screen
  ];
}
