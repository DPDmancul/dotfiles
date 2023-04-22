{ config, pkgs, lib, ... }:
{
  imports = [
    ../../nvim/lsp.nix
  ];

  home.packages = with pkgs; [
    openjdk17
  ];

  nvimLSP.jdtls  = {
    package = pkgs.jdt-language-server;
    config.cmd = ["jdt-language-server" "-data" "${config.home.homeDirectory}/.jdt/workspace"];
  };
}
