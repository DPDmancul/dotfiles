{ config, pkgs, lib, modules, ... }:
{
  imports = [
    /${modules}/home/xdg.nix
    /${modules}/home/packages/developing/dotnet.nix
    /${modules}/home/packages/developing/node.nix
  ];

  home.packages = with pkgs; [
    #<<<PereWork/home/packages-packages>>>
    keepassxc
    appimage-run
    unfree.dropbox-cli # TODO with home manager
    unfree.postman
    unfree.ngrok
  ];

  #<<<PereWork/home/packages>>>
}
