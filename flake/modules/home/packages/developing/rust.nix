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
    rust-tools-nvim
  ];
  nvimLSP.rust-tools = {
    packages = with pkgs; [
      rust-analyzer
      clippy
    ];
    config = { settings = { rust-analyzer =
      { checkOnSave = { command = "clippy"; }; }; }; };
  };
}
