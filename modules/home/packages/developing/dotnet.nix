{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    dotnet-sdk
  ];
  #programs.neovim.plugins = with pkgs.vimPlugins; [
  #];
}
