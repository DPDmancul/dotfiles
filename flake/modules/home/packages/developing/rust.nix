{ config, pkgs, lib, ... }:
{
  imports = [
    ../../nvim/lsp.nix
  ];

  home.packages = with pkgs; [
    cargo rustc clippy rustfmt
    gdb
  ];
  programs.neovim.plugins = with pkgs.vimPlugins; [
    rustaceanvim
  ];
  nvimLSP.rustaceanvim = {
    packages = with pkgs; [
      rust-analyzer
      clippy
    ];
  };
}
