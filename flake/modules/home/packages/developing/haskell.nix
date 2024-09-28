{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    ghc
    haskell-language-server
  ];
  programs.neovim.plugins = with pkgs.vimPlugins; [
    haskell-tools-nvim
  ];
}
