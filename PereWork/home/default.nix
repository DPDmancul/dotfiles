{ config, pkgs, lib, modules, ... }:
{
  imports = [
    /${modules}/home
    ./git.nix
    ./ssh.nix
    ./autorandr.nix
    ./firefox.nix
    ./rider.nix
    ./packages.nix
  ];

  #<<<PereWork/home>>>
}
