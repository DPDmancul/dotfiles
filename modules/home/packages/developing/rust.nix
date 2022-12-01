{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    cargo rustc clippy rustfmt
    gdb
  ];
  #programs.neovim.plugins = with pkgs.vimPlugins; [
  #];
}
