{ config, pkgs, lib, modules, ... }:
{
  imports = [
    /${modules}/home
    ./git.nix
    ./ssh.nix
    ./firefox.nix
    ./packages.nix
  ];

  #<<<PereWork/home>>>
}
