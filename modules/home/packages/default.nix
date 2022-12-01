{ config, pkgs, lib, ... }:
{
  imports = [
    ./utils.nix
    ./settings.nix
    ./libreoffice.nix
    ./nemo.nix
  ];
}
