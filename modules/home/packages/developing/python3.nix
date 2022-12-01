{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    python3
  ];
  #programs.neovim.plugins = with pkgs.vimPlugins; [
  #];
}
