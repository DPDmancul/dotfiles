{ config, pkgs, lib, ... }:
{
  imports = [
    ../../nvim/lsp.nix
  ];

  home.packages = with pkgs; [
    python3
  ];
  nvimLSP.pyright = pkgs.nodePackages.pyright;
}
